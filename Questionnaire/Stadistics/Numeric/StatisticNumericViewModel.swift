//
//  StatisticNumericViewModel.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class StatisticNumericViewModel: NSObject {

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
    
    func getAnswersRows() -> Observable<[DisplayableNumericAnswer]> {
        return getAnswersRows(sorting: .none)
    }
    
    func getAnswersRows(sorting : NumericAnswerSorting) -> Observable<[DisplayableNumericAnswer]> {
        return Observable.create { subscriber in
            self.getAnswers().subscribe(onNext: { answers in
                //Count ocurrences of each element
                var counts:[Int:Int] = [:]
                for answer in answers {
                    counts[answer.value] = (counts[answer.value] ?? 0) + 1
                }
                //Return result as array
                var result = [DisplayableNumericAnswer]()
                for entry in counts {
                    result.append(DisplayableNumericAnswer(value: entry.key, occurrences: entry.value))
                }
                //Apply sort
                result = self.sort(result, by: sorting)
                
                subscriber.onNext(result)
            }, onError: { error in subscriber.onError(error)})
        }
        
    }
    
    func sort(_ answers :[DisplayableNumericAnswer], by sorting:NumericAnswerSorting) -> [DisplayableNumericAnswer]{
        //Apply sort
        switch sorting{
        case .valueAscending:
            return answers.sorted{ Int($0.value)! < Int($1.value)!}
        case .valueDescending:
            return answers.sorted{ Int($0.value)! > Int($1.value)!}
        case .occurrencesAscending:
            return answers.sorted{ Int($0.occurrences)! < Int($1.occurrences)!}
        case .occurrencesDescending:
            return answers.sorted{ Int($0.occurrences)! > Int($1.occurrences)!}
        default:
            return answers
        }
    }
    
    func getStatsOnce() -> Observable<DisplayableNumericsStats>{
        return Observable.create {  subscriber in
            self.getAnswers().subscribe(onNext:{ answers in
                    let length = answers.count
                    //Calculate average
                    let total = answers.map{ $0.value }.reduce(0, +)
                    let average = Double(total) / Double(length)
                    //Calculate median
                    var median : Int
                    if length % 2 == 0{
                        median = (answers[length/2-1].value + answers[length/2].value) / 2
                    }else{
                        median = answers[length/2].value
                    }
                    //Calculate mode
                    var counts = [Int: Int]()
                    answers.forEach { counts[$0.value] = (counts[$0.value] ?? 0) + 1 } // Count the values with using forEach
                    let mode = counts.max(by: {$0.1 < $1.1})?.key
                    
                    //Calculate deviation
                    let sumOfSquaredAvgDiff = answers.map{ pow(Double($0.value) - average,2.0) }.reduce(0, {$0 + $1})
                    let deviation = sqrt(sumOfSquaredAvgDiff / Double(length))
                    
                    //Calculate min and max
                    let min = answers.min(by: {$0.value < $1.value})!.value
                    let max = answers.max(by: {$0.value < $1.value})!.value
                    
                    subscriber.onNext( DisplayableNumericsStats(
                        average: String(format: "%.2f", average),
                        median: String(format: "%d", median),
                        mode: String(format: "%d", mode!),
                        deviation: String(format: "%.2f", deviation),
                        min: String(format: "%d", min),
                        max: String(format: "%d", max)))

                }, onError: { error in subscriber.onError(error)})

        }
        
    }
    
}

enum NumericAnswerSorting{
    case none
    case valueAscending
    case valueDescending
    case occurrencesAscending
    case occurrencesDescending
}


struct DisplayableNumericAnswer{
    let value : String
    let occurrences : String
    
    init(value: Int, occurrences: Int) {
        self.value = String(value)
        self.occurrences = String(occurrences)
    }
}


struct DisplayableNumericsStats{
    let average : String
    let median : String
    let mode : String
    let deviation : String
    let min : String
    let max : String
    
    init(average:String, median:String, mode:String, deviation:String, min:String, max:String) {
        self.average = average
        self.median = median
        self.mode = mode
        self.deviation = deviation
        self.min = min
        self.max = max
    }
    
}
