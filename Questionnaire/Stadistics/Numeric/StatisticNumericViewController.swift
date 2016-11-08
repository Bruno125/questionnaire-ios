//
//  StatisticNumericViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class StatisticNumericViewController: BaseStatisticViewController {
    
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        titleLabel.text = question!.title
    }
}
