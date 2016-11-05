//
//  QuestionService.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

///Service that fetches a questionnaire from a remote source
class QuestionnaireService: QuestionnaireRepo {
    
    static let sharedInstance = QuestionnaireService()
    
    private let BASE_URL = "http://private-9d5799-questionnaireapp.apiary-mock.com/"
    
    func getQuestionnaire() -> Observable<Questionnaire> {
        return Observable.just(Questionnaire(id: "1", title: "Title", description: "Desc desc desc"))
    }
    
}
