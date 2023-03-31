//
//  OnboardingView.swift
//  forthgreen
//
//  Created by MACBOOK on 13/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class OnboardingView: UIPageViewController {
    
    var pageControl = UIPageControl()
    lazy var orderedViewControllers: [UIViewController] = {
        
        return [self.newVc(viewController: "Onboarding1"),
                self.newVc(viewController: "Onboarding2"),
                self.newVc(viewController: "Onboarding3")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.configurePageControl()
        // Do any additional setup after loading the view.
    }
    
    func goToNextPage(animated: Bool = true) {
      guard let currentViewController = orderedViewControllers.first else { return }
      guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
      setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
    }
    func goToPreviousPage(animated: Bool = true) {
      guard let currentViewController = orderedViewControllers.first else { return }
      guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
      setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
    }
    
    func newVc(viewController: String) -> UIViewController {
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // Adding the dot indicator at the bottom of the view. Current page will be blue and rest of indicators will be white
    func configurePageControl() {
        
        self.pageControl = UIPageControl(frame: CGRect(x:UIScreen.main.bounds.midX - 50 ,y: UIScreen.main.bounds.maxY - 280,width: 100,height: 50))
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(pageControl)
    }
}

//MARK: - PageViewController DataSource and Delegate Methods
extension OnboardingView: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in orderedViewControllers
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.orderedViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
    // viewControllerBefore
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    // viewController After
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}

extension OnboardingView {
  
}
