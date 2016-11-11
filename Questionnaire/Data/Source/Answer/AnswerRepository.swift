//
//  AnswerRepository.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

//This class determines how the answers should be
//accessed. In this case, it get it from core data source
class AnswerRepository: AnswerRepo {
    
    //Singleton
    static let sharedInstance = AnswerRepository()
    
    let coreDataSource = AnswerCoreData.sharedInstance
    
    func save(answers: [Answer]) -> Observable<Bool> {
        return coreDataSource.save(answers: answers)
    }
    
    func answersAvailable(forQuestionnaire questionnaireId: String) -> Observable<Bool> {
        return coreDataSource.answersAvailable(forQuestionnaire: questionnaireId)
    }
    
    func getAnswers() -> Observable<[Answer]> {
        return coreDataSource.getAnswers()
    }
    
    func getAnswers(forQuestion question:Question?) -> Observable<[Answer]>{
        return coreDataSource.getAnswers(forQuestion: question)
    }
    
}
