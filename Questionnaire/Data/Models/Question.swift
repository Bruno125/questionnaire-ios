//
//  Question.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

class Question {
    let id: String
    let name: String
    let type: String
    let title: String
    
    let choices: [Choice?]
    
    init(id :String, name: String, type: String, title :String, choices :[Choice?]) {
        self.id = id
        self.name = name
        self.type = type
        self.title = title
        self.choices = choices
    }
    
    static func parse(json : JSON) -> Question{
        let id = json["id"].stringValue
        let name = json["name"].stringValue
        let type = json["type"].stringValue
        let title = json["question"].stringValue
        
        let choices = json["choices"].arrayValue
            .map({ChoiceHelper.parse(questionId: id, type: getTypeFromString(type), json: $0)})
        
        return Question(id: id, name: name, type: type, title: title, choices: choices)
    }
    
    
    func getType() -> QuestionTypes{
        return Question.getTypeFromString(self.type)
    }
    
    static func getTypeFromString(_ type: String) -> QuestionTypes{
        switch type {
        case "text":
            return .text
        case "numeric":
            return .numeric
        case "single-option":
            return .singleOption
        case "multi-option":
            return .multipleOption
        default:
            return .none
        }
    }
    
}
