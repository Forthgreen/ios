//
//  InviteUsersVC.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 22/03/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class InviteUsersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewShimmer: UIView!
   
    var contacts = [(Character?, [CNContact])]()
    var sendResultArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
    //MARK: - configUI
    private func configUI() {
        viewShimmer.isHidden = false
        viewShimmer.isSkeletonable = true
        viewShimmer.showAnimatedGradientSkeleton()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.UserInfoCell.rawValue, bundle: nil),
                           forCellReuseIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue)
        self.setContactList()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setContactList() {
        DispatchQueue.global().async {
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactGivenNameKey,
                        CNContactPhoneNumbersKey,
                        CNContactImageDataAvailableKey,
                        CNContactImageDataKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
            var contactsNew = [CNContact]()
            let contactStore = CNContactStore()
            do {
                try contactStore.enumerateContacts(with: request) {
                    (contact, stop) in
                    // Array containing all unified contacts from everywhere
                    contactsNew.append(contact)
                }
            }
            catch {
                print("unable to fetch contacts")
            }
            DispatchQueue.main.async {
                let contacts1 = Dictionary(grouping: contactsNew) { $0.givenName.first ?? " " }
                self.contacts = contacts1.sorted {$0.key < $1.key }
                self.tableView.reloadData()
                self.viewShimmer.isHidden = true
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - TableView DataSource and Delegate Methods
extension InviteUsersVC: UITableViewDataSource, UITableViewDelegate {
    // numberOfRowsInSection
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts[section].1.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 11, height: 20)
        view.backgroundColor = .white

        view.textColor = UIColor(red: 0.592, green: 0.647, blue: 0.663, alpha: 1)
        view.font = UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 14)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.19
        // Line height: 20 pt
        // (identical to box height)
        view.textAlignment = .center
        view.attributedText = NSMutableAttributedString(string: self.contacts[section].0?.description ?? "",
                                                        attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        let parent = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 32))
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 11).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return parent
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.UserInfoCell.rawValue, for: indexPath) as? UserInfoCell else { return UITableViewCell() }
        cell.otherUserProfileBtn.isHidden = true
        let contacts = self.contacts[indexPath.section].1[indexPath.row]
        cell.nameLbl.text = contacts.givenName
        
        if contacts.imageDataAvailable, let imageData = contacts.imageData {
              // there is an image for this contact
            cell.profileImage.image = UIImage(data: imageData)
        } else {
            cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.placeholderForProfile.rawValue, urlString: "")
        }
        
        cell.bioLbl.isHidden = true
        cell.bioView.isHidden = true
        cell.userNameLbl.isHidden = false
        let contactNumber = contacts.phoneNumbers.first?.value.stringValue ?? ""
        cell.userNameLbl.text = contactNumber
        cell.userNameLbl.textColor = colorFromHex(hex: "3E4B4D")
        cell.followBtn.isHidden = false
        
        if self.sendResultArray.contains(contactNumber) {
            cell.followBtn.setTitle(STATIC_LABELS.invited.rawValue, for: .normal)
            cell.followBtn.backgroundColor = AppColors.paleGrey
            cell.followBtn.isUserInteractionEnabled = false
        }
        else {
            cell.followBtn.setTitle(STATIC_LABELS.invite.rawValue, for: .normal)
            cell.followBtn.backgroundColor = AppColors.turqoiseGreen
            cell.followBtn.isUserInteractionEnabled = true
        }
        
        cell.followBtn.tag = indexPath.row
        cell.followBtn.superview?.tag = indexPath.section
        cell.followBtn.addTarget(self, action: #selector(followUserBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    
    
    //MARK: - followUserBtnIsPressed
    @objc func followUserBtnIsPressed(sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "I’ve found this app and I think you’ll love it! Community, Brands and Restaurants, all 100% Vegan & Cruelty-Free. Tap: https://forthgreen.com/"
            controller.recipients = [self.contacts[sender.superview?.tag ?? 0].1[sender.tag].phoneNumbers.first?.value.stringValue ?? ""]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            self.view.sainiShowToastWithBackground(message: STATIC_LABELS.invitationNotSend.rawValue,
                                                   bgColor: UIColor.black,
                                                   font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!)
        }
    }
}

extension InviteUsersVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
        if result == .sent {
            self.sendResultArray.append(controller.recipients?.first ?? "")
            self.tableView.reloadData()
            self.view.sainiShowToastWithBackground(message: STATIC_LABELS.invitationSent.rawValue,
                                                   bgColor: UIColor.black,
                                                   font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!)
        } else {
            self.view.sainiShowToastWithBackground(message: STATIC_LABELS.invitationNotSend.rawValue,
                                                   bgColor: UIColor.black,
                                                   font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!)
        }
    }
}

