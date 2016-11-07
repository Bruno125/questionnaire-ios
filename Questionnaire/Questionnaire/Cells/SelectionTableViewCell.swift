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
    
    var mChoice : SelectionChoice?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        mChoice?.value = selected
    }
    
    func setData(choice: Choice){
        if let selectionChoice = choice as? SelectionChoice{
            mChoice = selectionChoice
            self.titleLabel.text = selectionChoice.label
            
        }
    }

}
