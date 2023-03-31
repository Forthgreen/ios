//
//  OnboardingVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/04/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        collectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.OnboardingCell.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.OnboardingCell.rawValue)
        
        delay(0.1) {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionView DataSource and Delegate Methods
extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ONBOARDING_HEADING.allCases.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.OnboardingCell.rawValue, for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
        cell.headingLbl.text = ONBOARDING_HEADING.allCases[indexPath.row].rawValue
        cell.onboardingImageView.image = UIImage(named: ONBOARDING_IMAGES.allCases[indexPath.row].rawValue)
        cell.contentLbl.text = ONBOARDING_TEXT.allCases[indexPath.row].rawValue
        cell.nextBtn.tag = indexPath.row
        cell.nextBtn.addTarget(self, action: #selector(nextBtnIsPressed), for: .touchUpInside)
        cell.skipBtn.addTarget(self, action: #selector(skipBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellH = collectionView.frame.size.height
        let cellw = SCREEN.WIDTH
        return CGSize(width: cellw, height: cellH)
    }
    
    //MARK: - nextBtnIsPressed
    @objc func nextBtnIsPressed(_ sender: UIButton) {
        if sender.tag == 3 {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.WelcomeVC.rawValue) as! WelcomeVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else {
            let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            if nextItem.count == 0 {
                return
            }
            self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }
    }
    
    //MARK: - skipBtnIsPressed
    @objc func skipBtnIsPressed(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.WelcomeVC.rawValue) as! WelcomeVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - UIScrollViewDelegate
extension OnboardingVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
