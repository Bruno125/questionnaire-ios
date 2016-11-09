//
//  AnswerRepository.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class AnswerRepository: AnswerRepo {
    
    //Singleton
    static let sharedInstance = AnswerRepository()
    
    let coreDataSource = AnswerCoreData.sharedInstance
    
    func save(answers: [Answer]) -> Observable<Bool> {
        return coreDataSource.save(answers: answers)
    }
    
    func getAnswers() -> Observable<[Answer]> {
        return coreDataSource.getAnswers()
    }
    
    func getAnswers(forQuestion question:Question?, sorted : Bool? = false) -> Observable<[Answer]>{
        return coreDataSource.getAnswers(forQuestion: question, sorted: sorted)
    }
    
}
