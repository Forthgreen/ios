
//
//  EasyMention.swift
//  EasyMention
//
//  Created by morteza.ghrdi@gmail.com on 09/29/2019.
//  Copyright (c) 2019 morteza.ghrdi@gmail.com. All rights reserved.
//

import UIKit
public protocol EasyMentionDelegate {
    func mentionSelected(in textView: EasyMention, mention: MentionItem)
    func startMentioning(in textView: EasyMention, mentionQuery: String)
//    func removeMentioning(in textView: EasyMention, mentionQuery: MentionItem)
    func getPostText(in textView: String)
}


public class EasyMention : UITextView {
    
    ////////////////////////////////////////////////////////////////////////
    // Public interface
    
    /// Force the results list to adapt to RTL languages
    open var forceRightToLeft = false
    
    // Move the table around to customize for your layout
    open var tableCornerRadius: CGFloat = 5.0
    open var mentionDelegate: EasyMentionDelegate?
    
    open var textViewBorderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = textViewBorderColor.cgColor
        }
    }
    open var textViewBorderWidth: CGFloat = 0.7 {
        didSet {
            self.layer.borderWidth = textViewBorderWidth
            
        }
    }
    
    public var isFromBottom: Bool = false
    
    let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    open var currentMentions = [Int :MentionItem]()
    fileprivate var mentionsIndexes = [Int:Int]()
    fileprivate var keyboardHieght:CGFloat?
    fileprivate var isMentioning = Bool()
    fileprivate var mentionQuery = String()
    fileprivate var startMentionIndex = Int()
    fileprivate var tableView = UITableView()
    fileprivate var timer: Timer? = nil
    fileprivate static let cellIdentifier = "MentionsCell"
    fileprivate var maxTableViewSize: CGFloat = 0
    fileprivate var mentions = [MentionItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    fileprivate var filtredMentions = [MentionItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.delegate = self
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = self.textViewBorderWidth
        self.layer.borderColor = self.textViewBorderColor.cgColor
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
        setupTableView()
        
    }
    
    override open func deleteBackward() {
        super.deleteBackward()
    }
    
    public func setMentions(mentions: [MentionItem]) {
        self.mentions = mentions
        self.filtredMentions = mentions
        
    }
    
    /// get current metions in textView
    ///
    /// - Returns: list of mentions
    public func getCurrentMentions() -> [MentionItem]{
        var mItems = [MentionItem]()
        for (_, mentions) in self.currentMentions {
            mItems.append(mentions)
        }
        return mItems
    }
    
    // Create the filter table
    fileprivate func setupTableView() {
        self.window?.addSubview(tableView)
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = tableCornerRadius
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        if forceRightToLeft {
            tableView.semanticContentAttribute = .forceRightToLeft
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        if isFromBottom {
            tableView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        else{
            tableView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }        
        
        tableView.isHidden = true
        tableView.register(MentionsCell.self, forCellReuseIdentifier: EasyMention.cellIdentifier)

        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    
    fileprivate func updatePosition(){
        self.tableView.frame.size.height = UIScreen.main.bounds.height - self.keyboardHieght! - self.frame.height
        
    }
    
    @IBInspectable open var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder.decoded
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = .lightGray
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder.decoded
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\((textContainerInset.left + 5) + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -((textContainerInset.left + 5) + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    func updateTablview() {
        mentionsIndexes = [Int:Int]()
        tableView.reloadInputViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)
    }
}

//MARK:- TableView Delegate

extension EasyMention: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredMentions.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EasyMention.cellIdentifier, for: indexPath) as? MentionsCell
        
        cell?.mentionItem = filtredMentions[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addMentionToTextView(name: filtredMentions[indexPath.row].name)
        currentMentions[self.startMentionIndex] = filtredMentions[indexPath.row]
        if mentionDelegate != nil {
            self.mentionDelegate?.mentionSelected(in: self, mention: filtredMentions[indexPath.row])
        }
        self.mentionQuery = ""
        self.isMentioning = false
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.isHidden = true
        })        
    }
}

//MARK:- TextView Delegate

extension EasyMention: UITextViewDelegate {
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.mentionDelegate?.startMentioning(in: self, mentionQuery: self.mentionQuery)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        self.mentionDelegate?.getPostText(in: textView.text)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let str = String(textView.text)
  //      print(str)
        var lastCharacter = ""
        
        if !str.isEmpty && range.location != 0{
            lastCharacter = String(str[str.index(before: str.endIndex)])
        }
        
        // when want to delete mention
        if mentionsIndexes.count != 0 {
            let  char = text.cString(using: .utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                for (index,length) in mentionsIndexes {
                    
                    if case index ... index+length = range.location {
                        // If start typing within a mention rang delete that name:
                      
                        textView.replace(textView.textRangeFromNSRange(range: NSMakeRange(index, length))!, withText: "")
                //        self.mentionDelegate?.removeMentioning(in: self, mentionQuery: self.currentMentions[index]!)
                        mentionsIndexes.removeValue(forKey: index)
                        self.currentMentions.removeValue(forKey: index)                        
                    }
                }
            }
        }
        
        if isMentioning {
            if text == " " || (text.count == 0 && self.mentionQuery == ""){ // If Space or delete the "@"
                self.mentionQuery = ""
                self.isMentioning = false
                self.filtredMentions = mentions
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.isHidden = true
                })
            }else if text.count == 0 {
                self.mentionQuery.remove(at: self.mentionQuery.index(before: self.mentionQuery.endIndex))
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(EasyMention.textViewDidEndEditing(_:)), userInfo: self, repeats: false)
            }else {
                self.mentionQuery += text.lowercased()
                timer?.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(EasyMention.textViewDidEndEditing(_:)), userInfo: self, repeats: false)
                
            }
        } else {
            print("*****  \(str)  *****")
            if text == "@" && ( range.location == 0 || lastCharacter == " ") { /* (Beginning of textView) OR (space then @) */
                //                self.filtredMentions = mentions
                self.isMentioning = true
                self.startMentionIndex = range.location
                self.mentionDelegate?.startMentioning(in: self, mentionQuery: self.mentionQuery)
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.isHidden = false
                    self.tableView.scrollsToTop = true
                    
                    if textView.text == "" {
                        delay(0.3) {
                            self.tableView.isHidden = false
                        }
                    }
                })
            }
        }
        return true
    }
    
    
    // Add a mention name to the UITextView
    func addMentionToTextView(name: String){
        
        mentionsIndexes[self.startMentionIndex] = name.count
        let range: Range<String.Index> = self.text.range(of: "@" + self.mentionQuery)!
        self.text.replaceSubrange(range, with: name)
        
        let theText = self.text + " "
        //        let theEndIndex = self.startMentionIndex + name.count
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: theText)
        
        if isFromBottom {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "charcoalGrey") as Any, range: NSMakeRange(0, attributedString.length))
        }
        else{
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black as Any, range: NSMakeRange(0, attributedString.length))
        }
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14) as Any, range: NSMakeRange(0, attributedString.length))
        
        for (startIndex, length) in mentionsIndexes {
            // Add attributes for the mention
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: colorFromHex(hex: "#3A86FF"), range: NSMakeRange(startIndex, length))
     //       attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: APP_FONT.buenosAiresBook.rawValue, size: 14) as Any, range: NSMakeRange(startIndex, length))
        }
        self.attributedText = attributedString
    }
    
}


extension UITextView{
    func textRangeFromNSRange(range:NSRange) -> UITextRange?
    {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location), let end = self.position(from: start, offset: range.length) else {
            return self.textRange(from: beginning, to: beginning)
            
        }
        return self.textRange(from: start, to: end)
    }
}
