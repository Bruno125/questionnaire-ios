//
//  StatisticTextViewModel.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class StatisticTextViewModel {

    private let source : AnswerRepo
    private let question : Question
    private let mDisposeBag = DisposeBag()
    private var mAnswers : [Answer]?
    
    init(question: Question, source: AnswerRepo) {
        self.question = question
        self.source = source
    }
    
    private func getAnswers() -> Observable<[Answer]> {
        if mAnswers != nil {
            // Inmediately return answers if we have already get them before
            return Observable.just(mAnswers!)
        }else{
            // Get answers from repository
            return source.getAnswers(forQuestion:question)
        }
        
    }
    
    func getAnswersRows() -> Observable<[DisplayableTextAnswer]> {
        return Observable.create { subscriber in
            self.getAnswers().subscribe(onNext: { answers in
                //Count ocurrences of each element
                var counts:[String:Int] = [:]
                for answer in answers {
                    if answer.label != nil{
                        counts[answer.label!] = (counts[answer.label!] ?? 0) + 1
                    }
                }
                //Return result as array
                var result = [DisplayableTextAnswer]()
                for entry in counts {
                    result.append(DisplayableTextAnswer(value: entry.key, occurrences: entry.value))
                }
                subscriber.onNext(result)
            }, onError: { error in subscriber.onError(error)})
        }
        
    }
}


struct DisplayableTextAnswer{
    let value : String
    let occurrences : String
    
    init(value: String, occurrences: Int) {
        self.value = value
        self.occurrences = String(occurrences)
    }
}
