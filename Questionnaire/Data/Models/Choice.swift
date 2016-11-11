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
    var questionnaireId : String {get}
    var questionId : String {get}
    var id : String {get}
    init(questionnaireId: String, questionId :String, json :JSON)
}

class ChoiceHelper{
    static func parse(questionnaireId: String, questionId :String, type : QuestionTypes, json : JSON) -> Choice?{
        switch type {
        case .text:
            return TextChoice(questionnaireId: questionnaireId, questionId: questionId, json: json)
        case .numeric:
            return NumberChoice(questionnaireId: questionnaireId, questionId: questionId, json: json)
        case .singleOption, .multipleOption:
            return SelectionChoice(questionnaireId: questionnaireId, questionId: questionId, json: json)
        default:
            return nil
        }
    }
}

class TextChoice : Choice{
    let id: String
    let questionId: String
    let questionnaireId: String
    let hint : String
    var value : String
    
    required init(questionnaireId: String, questionId :String, json : JSON) {
        self.questionnaireId = questionnaireId
        self.questionId = questionId
        self.id = json["id"].stringValue
        self.hint = json["hint"].stringValue
        value = ""
    }
    
    func getAnswer() -> Answer? {
        if !value.isEmpty{
            return Answer(questionnaireId: questionnaireId, questionId: questionId, choiceId: id, value: 0, label: value)
        }else{
            return nil
        }
    }
    
}

class NumberChoice : Choice{
    let id: String
    let questionId: String
    let questionnaireId: String
    let min : Int
    let max : Int
    var value : Int
    
    required init(questionnaireId: String, questionId :String, json :JSON) {
        self.questionnaireId = questionnaireId
        self.questionId = questionId
        self.id = json["id"].stringValue
        self.min = json["min"].intValue
        self.max = json["max"].exists() ? json["max"].intValue : 100
        self.value = 0
    }
    
    func getAnswer() -> Answer? {
        return Answer(questionnaireId: questionnaireId, questionId: questionId, choiceId: id, value: value, label: nil)
    }
}

class SelectionChoice : Choice{
    let id: String
    let questionId: String
    let questionnaireId: String
    let label : String
    var value : Bool
    
    required init(questionnaireId: String, questionId :String, json : JSON) {
        self.questionnaireId = questionnaireId
        self.questionId = questionId
        self.id = json["id"].stringValue
        self.label = json["label"].stringValue
        value = false
    }
    
    func getAnswer() -> Answer? {
        if value{
            return Answer(questionnaireId: questionnaireId, questionId: questionId, choiceId: id, value: 1, label: label)
        }else{
            return nil
        }
        
    }
}

