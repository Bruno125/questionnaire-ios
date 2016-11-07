//
//  Choice.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol Choice : Answerable{
    var questionId : String {get}
    var id : String {get}
    init(questionId :String, json :JSON)
}

class ChoiceHelper{
    static func parse(questionId :String, type : QuestionTypes, json : JSON) -> Choice?{
        switch type {
        case .text:
            return TextChoice(questionId: questionId, json: json)
        case .numeric:
            return NumberChoice(questionId: questionId, json: json)
        case .singleOption, .multipleOption:
            return OptionChoice(questionId: questionId, json: json)
        default:
            return nil
        }
    }
}

class TextChoice : Choice{
    let id: String
    let questionId: String
    let hint : String
    var value : String
    
    required init(questionId :String, json : JSON) {
        self.questionId = questionId
        self.id = json["id"].stringValue
        self.hint = json["hint"].stringValue
        value = ""
    }
    
    func getAnswer() -> Answer? {
        if !value.isEmpty{
            return Answer(questionId: questionId, choiceId: id, value: nil, label: value)
        }else{
            return nil
        }
    }
    
}

class NumberChoice : Choice{
    let id: String
    let questionId: String
    let min : Int
    let max : Int
    var value : Int
    
    required init(questionId :String, json :JSON) {
        self.questionId = questionId
        self.id = json["id"].stringValue
        self.min = json["min"].intValue
        self.max = json["max"].exists() ? json["max"].intValue : 100
        self.value = 0
    }
    
    func getAnswer() -> Answer? {
        return Answer(questionId: questionId, choiceId: id, value: 1, label: nil)
    }
}

class OptionChoice : Choice{
    let id: String
    let questionId: String
    let label : String
    var value : Bool
    
    required init(questionId :String, json : JSON) {
        self.questionId = questionId
        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        value = false
    }
    
    func getAnswer() -> Answer? {
        if value{
            return Answer(questionId: questionId, choiceId: id, value: 1, label: label)
        }else{
            return nil
        }
        
    }
}

