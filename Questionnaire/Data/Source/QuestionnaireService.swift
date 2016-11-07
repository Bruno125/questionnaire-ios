//
//  QuestionService.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON

///Service that fetches a questionnaire from a remote source
class QuestionnaireService: QuestionnaireRepo {
    
    static let sharedInstance = QuestionnaireService()
    
    private let QUESTIONS_URL = "https://private-9d5799-questionnaireapp.apiary-mock.com/questionnaire"
    
    func getQuestionnaire() -> Observable<Questionnaire> {
        
        return Observable<Questionnaire>.create { (observer) -> Disposable in
            let requestReference = Alamofire.request(self.QUESTIONS_URL)
                .responseJSON(completionHandler: { (response) in
                    if let value = response.result.value {
                        let questionnaire = Questionnaire.parse(json: JSON(value) )
                        observer.onNext(questionnaire)
                        observer.onCompleted()
                    }else if let error = response.result.error {
                        observer.onError(error)
                    }
                })
            
            return Disposables.create(with: { 
                requestReference.cancel()
            })
        }
        
    }
    
}
