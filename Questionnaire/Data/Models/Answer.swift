//
//  Answer.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import CoreData

class Answer: NSObject {
    
    let questionId : String
    let choiceId: String
    let value : Int
    let label : String?
    
    init(questionId :String, choiceId :String, value :Int, label :String?) {
        self.questionId = questionId
        self.choiceId = choiceId
        self.value = value
        self.label = label
    }
}

///Protocol which can provide an answer
protocol Answerable{
    func getAnswer() -> Answer?
}
