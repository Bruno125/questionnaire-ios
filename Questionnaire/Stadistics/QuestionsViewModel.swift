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
    private let answerSource : AnswerRepo
    private let mDisposeBag = DisposeBag()
    
    init(source : QuestionnaireRepo, answerRepo: AnswerRepo){
        self.source = source
        self.answerSource = answerRepo
    }
    
    func getQuestionsStream() -> Observable<[Question]>{
        return Observable.create{ subscriber in
            self.answerSource.answersAvailable().subscribe(onNext: { hasAnswers in
                if !hasAnswers {
                    subscriber.onError(QuestionsError.noAnswers)
                }else{
                    self.source.getQuestionnaire().map{ q in q.questions}.subscribe(
                            onNext: { r in subscriber.onNext(r)},
                            onError: { e in subscriber.onError(e)})
                        .addDisposableTo(self.mDisposeBag)
                }
            })
        }
    }
    
    
}

enum QuestionsError : Error {
    case noAnswers
}
