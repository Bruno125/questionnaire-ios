//
//  Injection.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class Injection: NSObject {

    static func getQuestionnaireRepo() -> QuestionnaireRepo{
        return QuestionnaireFileSource.sharedInstance
    }
    
    static func getQuestionnaireJsonName() -> String{
        return "questionnaireB"
    }
    
    static func getAnswerRepo() -> AnswerRepo {
        return AnswerRepository.sharedInstance
    }
    
}
