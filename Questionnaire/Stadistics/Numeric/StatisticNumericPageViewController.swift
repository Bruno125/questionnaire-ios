//
//  StatisticNumericPageViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class StatisticNumericPageViewController: UIPageViewController {

    var question : Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //We will provide the viewControllers
        dataSource = self
        setViewControllers([getGraphVC()], direction: .forward, animated: false, completion: nil)
    }
    
    func getGraphVC() -> NumericGraphViewController {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NumericGraphViewController") as! NumericGraphViewController
        vc.question = question
        return vc
    }
    
    func getStatsVC() -> NumericStatsViewController {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NumericStatsViewController") as! NumericStatsViewController
        vc.question = question
        return vc
    }
    
}

extension StatisticNumericPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: NumericStatsViewController.self) {
            return getGraphVC()
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: NumericGraphViewController.self) {
            return getStatsVC()
        } else {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
