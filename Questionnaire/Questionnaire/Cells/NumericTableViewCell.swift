//
//  NumericTableViewCell.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class NumericTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    var value = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionDecrease(_ sender: Any) {
        if value>0{
            value-=1
        }
        self.numberLabel.text = "\(value)"
    }
    
    @IBAction func actionIncrease(_ sender: Any) {
        value+=1
        self.numberLabel.text = "\(value)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
