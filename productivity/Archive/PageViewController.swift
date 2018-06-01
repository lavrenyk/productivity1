//
//  PageViewController.swift
//  productivity
//
//  Created by MoHapX on 15.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "workspacesVC"),
            self.getViewController(withIdentifier: "tasksVC")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    var selectedCategory: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // Navigate to next page
    func goNextPage(fowardTo position: Int) {
        let viewController = self.pages[position]
        setViewControllers([viewController], direction:
            UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {return nil}
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {return nil}
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pages.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = pages.index(of: firstViewController) else {return 0}
        
        return firstViewControllerIndex
    }
}


extension PageViewController: UIPageViewControllerDelegate {
    
}


