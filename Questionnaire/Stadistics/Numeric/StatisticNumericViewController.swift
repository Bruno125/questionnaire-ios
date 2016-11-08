//
//  StatisticNumericViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class StatisticNumericViewController: BaseStatisticViewController {
    
    @IBOutlet var statsContainerView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        titleLabel.text = question!.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil {
            return
        }
        
        switch segue.identifier! {
        case "StatsContainerSegue":
            (segue.destination as? StatisticNumericPageViewController)?.question = question
        default:
            break
        }
    }
}
