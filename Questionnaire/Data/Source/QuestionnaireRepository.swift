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
    
    let serviceSource = QuestionnaireService.sharedInstance
    
    ///Will try to get the questionnaire from the repo, but if that fails,
    ///will get the questionnaire info from an static inner json file
    func getQuestionnaire() -> Observable<Questionnaire> {
        return serviceSource.getQuestionnaire()
    }
    
}
