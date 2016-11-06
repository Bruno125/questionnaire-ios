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
    
    init(source: QuestionnaireRepo, questionnaire: Questionnaire){
        mSource = source
        mQuestionnaire = questionnaire
        mCurrentIndex = -1
    }
    
    private let textSubject = PublishSubject<Question>()
    private let numberSubject = PublishSubject<Question>()
    private let singleOptionSubject = PublishSubject<Question>()
    private let multipleOptionSubject = PublishSubject<Question>()
    private let questionnaireStateSubject = PublishSubject<DisplayableQuestionnaireState>()
    
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
    
    func getQuestionnaireStateUpdates() -> Observable<DisplayableQuestionnaireState>{
        return questionnaireStateSubject.asObservable()
    }
    
    func startQuestionnaire() -> Observable<Questionnaire>{
        mCurrentIndex = -1
        
        return Observable.create { observer in
            self.mSource.getQuestionnaire().subscribe(onNext: { q in
                //Save question locally
                self.mQuestionnaire = q
                //Return the question to the observable
                observer.onNext(q)
                //Inmediately start questionnaire
                self.sendNextQuestion()
            }).addDisposableTo(self.mDisposeBag)
            
            return Disposables.create()
        }
    }
    
    func sendNextQuestion(){
        //Do nothing if we have no questions or if we are already at the final step
        if mQuestionnaire == nil || mCurrentIndex + 1 >= mQuestionnaire!.questions.count{
            return
        }
        //Update current question
        mCurrentIndex += 1
        //Develiver question
        deliverQuestion()
    }
    
    func sendPrevioustQuestion(){
        //Do nothing if we have no questions or if we are already at the first step
        if mCurrentIndex == 0{
            return
        }
        //Update current question
        mCurrentIndex -= 1
        //Develiver question
        deliverQuestion()
    }
    
    func deliverQuestion(){
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

        //Send questionnaire state update
        questionnaireStateSubject.onNext(DisplayableQuestionnaireState(
            hint: getQuestionnaireHint(),
            question: question.title,
            questionCount: getQuestionnaireCount(),
            currentIndex: mCurrentIndex))
        
    }
    
    private func getQuestionnaireHint() -> String{
        return "Question \(mCurrentIndex + 1) of \(getQuestionnaireCount())"
    }
    
    private func getQuestionnaireCount() -> Int{
        return mQuestionnaire == nil ? 0 : mQuestionnaire!.questions.count
    }
    
    private func getCurrentIndex() -> Int {
        return mCurrentIndex
    }
    
}
