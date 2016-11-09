//
//  AnswerRepo.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

protocol AnswerRepo {
    func save(answers:[Answer]) -> Observable<Bool>
    func getAnswers() -> Observable<[Answer]>
    func getAnswers(forQuestion question:Question?, sorted : Bool?) -> Observable<[Answer]>
}
