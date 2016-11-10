//
//  QuestionnaireFileSource.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 06/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

///Questionnaire provider that obtains the data from a local json file
class QuestionnaireFileSource: QuestionnaireRepo {

    static let sharedInstance = QuestionnaireFileSource()
    
    func getQuestionnaire() -> Observable<Questionnaire> {
        return Observable<Questionnaire>.create { (observer) -> Disposable in
            do{
                let json = try self.readJsonFile(file: Injection.getQuestionnaireJsonName())
                let questionnaire = Questionnaire.parse(json: json)
                observer.onNext(questionnaire)
            }catch let error{
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    private func readJsonFile(file: String) throws -> JSON{
        if let path = Bundle.main.path(forResource: file, ofType:"json"){
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                return JSON(data:data)
            }catch let error{
                throw error
            }
        }else{
            throw ReadFileError.invalidFile
        }
    }
}

enum ReadFileError : Error{
    case invalidFile
}
