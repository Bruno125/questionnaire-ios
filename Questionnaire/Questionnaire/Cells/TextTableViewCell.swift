//
//  TextTableViewCell.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell, ChoiceCell,UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    private var mChoice : TextChoice?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(choice: Choice){
        if let textChoice = choice as? TextChoice{
            self.mChoice = textChoice
            self.textField.delegate = self
            self.textField.placeholder = textChoice.hint
            self.textField.addTarget(self, action: #selector(listenTextFieldChanges), for: UIControlEvents.editingChanged)
        }
    }
    
    func listenTextFieldChanges (textField : UITextField){
        self.mChoice?.value = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
