//
//  AnswerCoreData.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class AnswerCoreData: AnswerRepo {
    
    //Singleton
    static let sharedInstance = AnswerCoreData()
    
    private let ENTITY_NAME = "ManagedAnswer"
    
    func save(answers: [Answer]) -> Observable<Bool> {
        //Get managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return Observable.just(false)
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for answer in answers {
            //Create managed object
            let managedAnswer = NSEntityDescription.insertNewObject(forEntityName: self.ENTITY_NAME, into: managedContext) as! ManagedAnswer
            //Assign values to managed object
            managedAnswer.questionId = answer.questionId
            managedAnswer.choiceId = answer.choiceId
            managedAnswer.label = answer.label
            managedAnswer.value = Int64(answer.value)
        }
        
        //Save answers
        do {
            try managedContext.save()
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }

    }
    
    func answersAvailable() -> Observable<Bool> {
        return getAnswers().map{ $0.count != 0}
    }
    
    func getAnswers() -> Observable<[Answer]> {
        return getAnswers(forQuestion: nil)
    }
    
    func getAnswers(forQuestion question:Question?) -> Observable<[Answer]>{
        //Get managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return Observable.just([])
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //Formulate request
        let fetchRequest = NSFetchRequest<ManagedAnswer>(entityName: self.ENTITY_NAME)
        if question != nil {
            fetchRequest.predicate = NSPredicate(format: "questionId == %@", question!.id)
        }
        
        
        //Get ManagedAnswers from core data and convert them to Answers
        var result = [Answer]()
        do {
            let managedAnswers = try managedContext.fetch(fetchRequest)
            for managedAnswer in managedAnswers {
                result.append(Answer(questionId: managedAnswer.questionId!,
                                     choiceId: managedAnswer.choiceId!,
                                     value: Int(managedAnswer.value),
                                     label: managedAnswer.label))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return Observable.just(result)


    }
    
}
