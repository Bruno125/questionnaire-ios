//
//  DisplayableQuestionnaireState.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 06/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class DisplayableQuestionnaireState {
    
    let hint : String
    let question : String
    let questionType : QuestionTypes
    let questionsCount : Int
    let currentIndex : Int
    
    init(hint :String, question: String, type :QuestionTypes, questionCount :Int, currentIndex :Int) {
        self.hint = hint
        self.question = question
        self.questionType = type
        self.questionsCount = questionCount
        self.currentIndex = currentIndex
    }
    
}
