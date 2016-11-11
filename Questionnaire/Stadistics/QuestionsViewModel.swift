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
            //Get questionnaire
            self.source.getQuestionnaire().subscribe( onNext: { q in
                //Check if there are answers for this questionnaire
                self.answerSource.answersAvailable(forQuestionnaire: q.id).subscribe(onNext: { hasAnswers in
                    if hasAnswers { //We can display the questions
                        subscriber.onNext(q.questions)
                    }else{ //No answers for this questionnaire!
                        subscriber.onError(QuestionsError.noAnswers)
                    }
                },onError: { e in subscriber.onError(e)}).addDisposableTo(self.mDisposeBag)
            },onError: { e in subscriber.onError(e)})
        }
    }
    
    
}

enum QuestionsError : Error {
    case noAnswers
}
