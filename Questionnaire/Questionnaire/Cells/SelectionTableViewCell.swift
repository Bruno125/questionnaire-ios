//
//  SelectionTableViewCell.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 06/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell, ChoiceCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(choice: Choice){
        if let optionChoice = choice as? OptionChoice{
            self.titleLabel.text = optionChoice.label
        }
    }

}
