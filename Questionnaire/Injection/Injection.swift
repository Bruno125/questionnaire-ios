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
        return QuestionnaireRepository.sharedInstance
    }
    
    static func getAnswerRepo() -> AnswerRepo {
        return AnswerRepository.sharedInstance
    }
    
}
