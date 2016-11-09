//
//  SingleAnswerTableViewCell.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class SingleAnswerTableViewCell: UITableViewCell {

    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var occurrencesLabel: UILabel!
    @IBOutlet var percentageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
