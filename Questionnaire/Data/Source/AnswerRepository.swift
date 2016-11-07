//
//  AnswerRepository.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class AnswerRepository: AnswerRepo {
    
    //Singleton
    static let sharedInstance = AnswerRepository()
    
    let coreDataSource = AnswerCoreData.sharedInstance
    
    func save(answers: [Answer]) -> Bool {
        return coreDataSource.save(answers: answers)
    }
    
    func getAll() -> [Answer] {
        return coreDataSource.getAll()
    }
    
}
