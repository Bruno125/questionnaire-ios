//
//  Question.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

class Choice{
    let label : String
    var value : Int = 0
    
    init(label: String, value :Int) {
        self.label = label
        self.value = value
    }
}

class Question {
    let name: String
    let type: String
    let title: String
    
    let choices: [Choice]
    
    init(name: String, type: String, title :String, choices :[Choice]) {
        self.name = name
        self.type = type
        self.title = title
        self.choices = choices
    }
    
    static func parse(json : JSON) -> Question{
        let name = json["name"].stringValue
        let type = json["type"].stringValue
        let title = json["title"].stringValue
        
        let choices = json["choices"].arrayValue.map({
            Choice(label: $0["label"].stringValue, value: $0["label"].intValue)
        })
        
        return Question(name: name, type: type, title: title, choices: choices)
    }
    
    
    func getType() -> QuestionTypes{
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
