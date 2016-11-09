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
    
    init(question: Question, source: AnswerRepo) {
        self.question = question
        self.source = source
    }
    
    func getAnswersOnce(forQuestion question: Question) -> Observable<[Answer]>{
        return source.getAnswers(forQuestion:question, sorted: false)
    }
    
    func getStatsOnce() -> Observable<DisplayableNumericsStats>{
        return Observable.create {  subscriber in
            self.source.getAnswers(forQuestion: self.question, sorted: true)
                .subscribe(onNext:{ answers in
                    
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

                })

        }
        
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
