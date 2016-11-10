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
    private let mAnswerSource : AnswerRepo
    private let mDisposeBag = DisposeBag()
    private var mQuestionnaire: Questionnaire?
    private var mCurrentIndex = -1
    
    private var mAnswers = [Answer]()
    private var mAnswersTrace = [Int]()
    
    init(source: QuestionnaireRepo, answerRepo: AnswerRepo) {
        mSource = source
        mAnswerSource = answerRepo
    }
    
    init(source: QuestionnaireRepo, answerRepo: AnswerRepo, questionnaire: Questionnaire){
        mSource = source
        mAnswerSource = answerRepo
        mQuestionnaire = questionnaire
        mCurrentIndex = -1
    }
    
    private let questionsSubject = PublishSubject<Question>()
    private let questionnaireStateSubject = PublishSubject<DisplayableQuestionnaireState>()
    private let errorsSubject = PublishSubject<String>()
    private let finishSubject = PublishSubject<Bool>()
    
    func getQuestionStream() -> Observable<Question> {
        return questionsSubject.asObservable()
    }
    
    
    func getQuestionnaireStateUpdates() -> Observable<DisplayableQuestionnaireState>{
        return questionnaireStateSubject.asObservable()
    }
    
    func getErrorStream() -> Observable<String>{
        return errorsSubject.asObservable()
    }
    
    func getFinishOnce() -> Observable<Bool>{
        return finishSubject.asObservable()
    }
    
    func startQuestionnaire() -> Observable<Questionnaire>{
        mCurrentIndex = -1
        mAnswers = [Answer]()
        mAnswersTrace = [Int]()
        
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
        if mQuestionnaire == nil {
            return
        }
        
        //Get answers for the current question
        if mCurrentIndex != -1{
            let question = getCurrentQuestion()!
            let answersForCurrentQuestion = question.getAnswers()
            //Throw error if no answer available
            if answersForCurrentQuestion.isEmpty {
                errorsSubject.onNext(getErrorMessage(type: question.getType()))
                return
            }
            
            //Append answers
            mAnswers.append(contentsOf: answersForCurrentQuestion)
            mAnswersTrace.append(answersForCurrentQuestion.count)
        }
        
        
        let isLast = mCurrentIndex + 1 >= mQuestionnaire!.questions.count
        if isLast {
            //Finish and save answers
            mAnswerSource.save(answers: mAnswers).subscribe(onNext: { sucess in
                if sucess {
                    //Notify questionnaire completion
                    self.finishSubject.onNext(true)
                }else{
                    //Remove answers from previous question
                    self.mAnswers.removeLast(self.mAnswersTrace.removeLast())
                }
            }).addDisposableTo(self.mDisposeBag)
        }else{
            //Procceed to next question
            mCurrentIndex += 1
            //Develiver next question
            deliverQuestion()
        }
        
    }
    
    func sendPreviousQuestion(){
        //Do nothing if we have no questions
        if mQuestionnaire == nil || mCurrentIndex == 0{
            return
        }
        
        //Remove answers from previous question
        mAnswers.removeLast(mAnswersTrace.removeLast())
        
        //Update current question
        mCurrentIndex -= 1
        //Develiver question
        deliverQuestion()
    }
    
    func deliverQuestion(){
        //Get question
        let question = getCurrentQuestion()!

        //Send questionnaire state update
        questionnaireStateSubject.onNext(DisplayableQuestionnaireState(
            hint: getQuestionnaireHint(),
            question: question.title,
            type: question.getType(),
            questionCount: getQuestionnaireCount(),
            currentIndex: mCurrentIndex))
        
        //Deliver question choices stream
        questionsSubject.onNext(question)
    }
    
    private func getCurrentQuestion() -> Question?{
        return mQuestionnaire?.questions[mCurrentIndex]
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
    
    private func getErrorMessage(type: QuestionTypes) -> String{
        switch type {
        case .text:
            return "Fill the text field"
        case .numeric:
            return "Invalid number"
        case .singleOption:
            return "Pick one option"
        case .multipleOption:
            return "Pick at least one option"
        default:
            return ""
        }
    }
    
}
