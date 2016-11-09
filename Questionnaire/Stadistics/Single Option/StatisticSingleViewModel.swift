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
            return source.getAnswers(forQuestion:question)
        }
    }
    
    func getAnswersRows() -> Observable<[DisplayableSingleAnswer]> {
        return getAnswersRows(sorting: .none)
    }
    
    func getAnswersRows(sorting :SingleAnswerSorting) -> Observable<[DisplayableSingleAnswer]> {
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
                
                result = self.sort(result, by: sorting)
                
                subscriber.onNext(result)
            }, onError: { error in subscriber.onError(error)})
        }
    }
    
    func sort(_ answers :[DisplayableSingleAnswer], by sorting:SingleAnswerSorting) -> [DisplayableSingleAnswer]{
        //Apply sort
        switch sorting{
        case .value:
            return answers.sorted{ $0.value.localizedCaseInsensitiveCompare($1.value) == .orderedAscending}
        case .occurrences:
            return answers.sorted{ Int($0.occurrences)! > Int($1.occurrences)!}
        case .percentage:
            return answers.sorted{ $0.percentageValue > $1.percentageValue}
        default:
            return answers
        }
    }
    
    
}

enum SingleAnswerSorting{
    case none
    case value
    case occurrences
    case percentage
}

struct DisplayableSingleAnswer{
    let value : String
    let occurrences : String
    let percentage: String
    let percentageValue : Double
    
    init(value: String, occurrences: Int, percentage: Double) {
        self.value = value
        self.occurrences = String(occurrences)
        self.percentage = String(format: "%.2f", percentage*100)
        self.percentageValue = percentage
    }
}
