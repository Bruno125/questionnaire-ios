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
        return getAnswersRows(sorting: .none)
    }
    
    func getAnswersRows(sorting: TextAnswerSorting) -> Observable<[DisplayableTextAnswer]> {
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
                //Apply sort
                result = self.sort(result, by: sorting)
                
                subscriber.onNext(result)
            }, onError: { error in subscriber.onError(error)})
        }
        
    }
    
    
    func sort(_ answers :[DisplayableTextAnswer], by sorting:TextAnswerSorting) -> [DisplayableTextAnswer]{
        //Apply sort
        switch sorting{
        case .value:
            return answers.sorted{ $0.value.localizedCaseInsensitiveCompare($1.value) == .orderedAscending}
        case .occurrences:
            return answers.sorted{ Int($0.occurrences)! > Int($1.occurrences)!}
        default:
            return answers
        }
    }
}

enum TextAnswerSorting{
    case none
    case value
    case occurrences
}

struct DisplayableTextAnswer{
    let value : String
    let occurrences : String
    
    init(value: String, occurrences: Int) {
        self.value = value
        self.occurrences = String(occurrences)
    }
}
