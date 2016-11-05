//
//  QuestionnaireViewModel.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class QuestionnaireViewModel: NSObject {
    
    private let mSource : QuestionnaireRepo
    private let mDisposeBag = DisposeBag()
    private var mQuestionnaire: Questionnaire?
    private var mCurrentIndex = -1
    
    init(source: QuestionnaireRepo) {
        mSource = source
    }
    
    private let textSubject = PublishSubject<Question>()
    private let numberSubject = PublishSubject<Question>()
    private let singleOptionSubject = PublishSubject<Question>()
    private let multipleOptionSubject = PublishSubject<Question>()
    
    func getTextQuestionStream() -> Observable<Question> {
        return textSubject.asObservable()
    }
    
    func getNumberQuestionStream() -> Observable<Question> {
        return numberSubject.asObservable()
    }
    
    func getSingleOptionQuestionStream() -> Observable<Question> {
        return singleOptionSubject.asObservable()
    }
    
    func getMultipleOptionQuestionStream() -> Observable<Question> {
        return multipleOptionSubject.asObservable()
    }
    
    func startQuestionnaire(){
        mCurrentIndex = -1
        mSource.getQuestionnaire().subscribe(onNext: { q in
            self.mQuestionnaire = q
            self.sendNextQuestion()
        }).addDisposableTo(mDisposeBag)
    }
    
    func sendNextQuestion(){
        //Do nothing if we have no questions or if we are already at the final step
        if mQuestionnaire == nil || mCurrentIndex + 1 >= mQuestionnaire!.questions.count{
            return
        }
        
        //Update current question
        mCurrentIndex += 1
        //Get question
        let question = mQuestionnaire!.questions[mCurrentIndex]
        //Deliver the question to the appropiate stream depending on its type
        switch question.getType() {
        case .text:
            textSubject.onNext(question)
        case .numeric:
            numberSubject.onNext(question)
        case .singleOption:
            singleOptionSubject.onNext(question)
        case .multipleOption:
            multipleOptionSubject.onNext(question)
        default: break
        }
        
    }
    
}
