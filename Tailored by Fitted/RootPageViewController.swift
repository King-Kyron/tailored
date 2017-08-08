//
//  RootPageViewController.swift
//  Tailored by Fitted
//
//  Created by Kyron Loggins on 8/7/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var vcArray: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let camVC = storyBoard.instantiateViewController(withIdentifier: "CamVC")
        let appVC = storyBoard.instantiateViewController(withIdentifier: "AppVC")
        let messVC = storyBoard.instantiateViewController(withIdentifier: "MessVC")
        
        return [appVC, camVC, messVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource  = self
        self.delegate = self
        if let firstViewController = self.vcArray.first{
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        guard let vcIndex = vcArray.index(of: viewController) else {    return nil  }
        
        let prevIndex = vcIndex - 1
        
        guard prevIndex >= 0 else { return vcArray.last }
        
        guard vcArray.count > prevIndex else{ return nil }
        
        return vcArray[prevIndex]
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let vcIndex = vcArray.index(of: viewController) else {    return nil  }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex < vcArray.count else { return vcArray.first }
        
        guard vcArray.count > nextIndex else{ return nil }
        
        return vcArray[nextIndex]
        
    }
    
    
    
}
