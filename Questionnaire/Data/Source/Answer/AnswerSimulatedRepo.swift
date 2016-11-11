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
    
    func answersAvailable(forQuestionnaire questionnaireId:String ) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func getAnswers() -> Observable<[Answer]> {
        return getAnswers(forQuestion: nil)
    }
    
    func getAnswers(forQuestion question: Question?) -> Observable<[Answer]> {
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
                        
                        let qId = tempQuestion.questionnaireId
                        let id = tempQuestion.id
                        let choice = String(arc4random_uniform(UInt32(tempQuestion.choices.count)))
                        let random = Int(arc4random_uniform(5))
                        
                        switch tempQuestion.getType() {
                        case .text:
                            answers.append(Answer(questionnaireId: qId,
                                                  questionId: id,
                                                  choiceId: choice,
                                                  value: 0,
                                                  label: "Answer \(random)"))
                        case .numeric:
                            answers.append(Answer(questionnaireId: qId,
                                                  questionId: id,
                                                  choiceId: choice,
                                                  value: random,
                                                  label: nil))
                        case .singleOption:
                            answers.append(Answer(questionnaireId: qId, questionId: id, choiceId: choice, value: 1, label: "Choice \(random)"))
                        case .multipleOption:
                            var aux = 0
                            var atLeastOnce = false
                            while aux < tempQuestion.choices.count {
                                let selected = (arc4random_uniform(UInt32(10)) == 2)
                                if selected {
                                    let selectedChoice = tempQuestion.choices[aux]?.id
                                    atLeastOnce = true
                                    answers.append(Answer(questionnaireId: qId,
                                                          questionId: id,
                                                          choiceId: selectedChoice!,
                                                          value: 1,
                                                          label: "Choice \(aux)"))
                                }
                                aux += 1
                            }
                            if !atLeastOnce {
                                answers.append(Answer(questionnaireId: qId,
                                                      questionId: id,
                                                      choiceId: choice,
                                                      value: 1,
                                                      label: "Choice \(aux)"))
                            }
                            
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
