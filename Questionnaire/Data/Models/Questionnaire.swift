//
//  Questionnaire.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

class Questionnaire {
    
    let id: String
    let title: String
    let description: String
    var questions: [Question] = []
    
    convenience init(id: String, title: String, description: String) {
        self.init(id: id, title: title, description: description)
    }
    
    init(id: String, title: String, description: String, questions: [Question]) {
        self.id = id
        self.title = title
        self.description = description
        self.questions = questions
    }
    
    static func parse(json: JSON) -> Questionnaire{
        
        let id = json["id"].stringValue
        let title = json["title"].stringValue
        let description = json["description"].stringValue
        
        let questions = json["questions"].arrayValue.map({
            Question.parse(json: $0)
        })
        
        return Questionnaire(id: id, title: title, description: description, questions: questions)
    }
    
}
