//
//  NumericTableViewCell.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class NumericTableViewCell: UITableViewCell, ChoiceCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    var value = 0
    var min = 0
    var max = 1000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionDecrease(_ sender: Any) {
        if value>min{
            updateValue(value - 1)
        }
    }
    
    @IBAction func actionIncrease(_ sender: Any) {
        if value < max {
            updateValue(value + 1)
        }
    }
    
    func setData(choice: Choice) {
        if let numberChoice = choice as? NumberChoice{
            min = numberChoice.min
            max = numberChoice.max
            updateValue(numberChoice.value)
        }
    }
    
    func updateValue(_ newValue : Int){
        value = newValue
        self.numberLabel.text = "\(value)"
    }
    
}
