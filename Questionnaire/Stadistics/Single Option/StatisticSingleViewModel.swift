//
//  StatisticSingleViewModel.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class StatisticSingleViewModel {
    
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
            return source.getAnswers(forQuestion:question, sorted: false)
        }
    }
    
    func getAnswersRows() -> Observable<[DisplayableSingleAnswer]> {
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
                var result = [DisplayableSingleAnswer]()
                for entry in counts {
                    let percentage = Double(entry.value) / Double(answers.count)
                    result.append(DisplayableSingleAnswer(value: entry.key, occurrences: entry.value,percentage: percentage))
                }
                subscriber.onNext(result)
            }, onError: { error in subscriber.onError(error)})
        }
        
    }
}


struct DisplayableSingleAnswer{
    let value : String
    let occurrences : String
    let percentage: String
    
    init(value: String, occurrences: Int, percentage: Double) {
        self.value = value
        self.occurrences = String(occurrences)
        self.percentage = String(percentage)
    }
}
