//
//  QuestionsViewModel.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class QuestionsViewModel {

    private let source : QuestionnaireRepo
    
    init(source : QuestionnaireRepo){
        self.source = source
    }
    
    func getQuestionsStream() -> Observable<[Question]>{
        return source.getQuestionnaire().map{ q in q.questions}
    }
    
    
}
