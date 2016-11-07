//
//  AnswerCoreData.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import CoreData

class AnswerCoreData: AnswerRepo {
    
    //Singleton
    static let sharedInstance = AnswerCoreData()
    
    private let ENTITY_NAME = "ManagedAnswer"
    
    func save(answers: [Answer]) -> Bool {
        
        //Get managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for answer in answers {
            //Create managed object
            let managedAnswer = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: managedContext) as! ManagedAnswer
            //Assign values to managed object
            managedAnswer.questionId = answer.questionId
            managedAnswer.choiceId = answer.choiceId
            managedAnswer.label = answer.label
            managedAnswer.value = answer.value == nil ? Int64(0) : Int64(answer.value!)
        }
        
        //Save answers
        do {
            try managedContext.save()
            return true
        } catch {
            return false
        }
        
    }
    
    func getAll() -> [Answer] {
        //Get managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //Formulate request
        let fetchRequest = NSFetchRequest<ManagedAnswer>(entityName: ENTITY_NAME)
        
        //Get ManagedAnswers from core data and convert them to Answers
        var result = [Answer]()
        do {
            let managedAnswers = try managedContext.fetch(fetchRequest)
            for managedAnswer in managedAnswers {
                result.append(Answer(questionId: managedAnswer.questionId!,
                                             choiceId: managedAnswer.choiceId!,
                                             value: managedAnswer.value,
                                             label: managedAnswer.label))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return result
        
    }
    
    
    
}
