//
//  AnswerSimulatedRepo.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class AnswerSimulatedRepo: AnswerRepo {
    
    static let sharedInstance = AnswerSimulatedRepo()

    func save(answers: [Answer]) -> Observable<Bool> {
        return AnswerCoreData.sharedInstance.save(answers: answers)
    }
    
    func getAnswers() -> Observable<[Answer]> {
        return getAnswers(forQuestion: nil, sorted: true)
    }
    
    func getAnswers(forQuestion question: Question?, sorted: Bool?) -> Observable<[Answer]> {
        return Observable.create { subscriber in
            
            QuestionnaireRepository.sharedInstance.getQuestionnaire().subscribe(onNext: { questionnaire in
                //Answers that we will return
                var answers = [Answer]()
                //Simulate X answers
                80.times{
                    for tempQuestion in questionnaire.questions {
                        //If is requesting specific answers for a question, filter by its id
                        if question != nil && tempQuestion.id != question?.id{
                            continue
                        }
                        
                        let id = tempQuestion.id
                        let choice = String(arc4random_uniform(UInt32(tempQuestion.choices.count)))
                        let random = Int(arc4random_uniform(100))
                        
                        switch tempQuestion.getType() {
                        case .text:
                            answers.append(Answer(questionId: id, choiceId: choice, value: 0, label: "Answer \(random)"))
                        case .numeric:
                            answers.append(Answer(questionId: id, choiceId: choice, value: random, label: nil))
                        case .singleOption:
                            answers.append(Answer(questionId: id, choiceId: choice, value: 1, label: nil))
                        case .multipleOption:
                            break //TODO
                        default:
                            break
                        }
                    }
                }
                //Return answers
                subscriber.onNext(answers)
            })
        }

    }
    
}
