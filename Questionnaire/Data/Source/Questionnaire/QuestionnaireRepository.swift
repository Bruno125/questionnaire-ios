//
//  QuestionnaireRepository.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

///Provides the logic to access the questionnaire data. Can either
///get it via the web service or by reading a .json file
class QuestionnaireRepository: QuestionnaireRepo {
    //Singleton
    static let sharedInstance = QuestionnaireRepository()
    private var mQuestionnaire : Questionnaire?
    
    let serviceSource = QuestionnaireService.sharedInstance
    let fileSource = QuestionnaireFileSource.sharedInstance
    let mDisposableBag = DisposeBag()
    
    ///Will try to get the questionnaire from the repo, but if that fails,
    ///will get the questionnaire info from an static inner json file
    func getQuestionnaire() -> Observable<Questionnaire> {
        //If we have already get it, there is no need to go to the ws or BD again
        if mQuestionnaire != nil {
            return Observable.just(mQuestionnaire!)
        }
        
        
        return Observable.create{ (observer) -> Disposable in
            //Try to get questionnaire from service
            self.serviceSource.getQuestionnaire().subscribe(onNext: { questionnaire in
                self.mQuestionnaire = questionnaire
                observer.onNext(questionnaire)
            }, onError: { error in
                //We couldn't get the info from the remote service, so
                //we'll try to get it from a local json file
                self.fileSource.getQuestionnaire().subscribe(onNext: { questionnaire in
                    self.mQuestionnaire = questionnaire
                    observer.onNext(questionnaire)
                },onError: { error in
                    observer.onError(error)
                }).addDisposableTo(self.mDisposableBag)
            }).addDisposableTo(self.mDisposableBag)
            
            return Disposables.create()
        }
        
        
        
    }
    
}
