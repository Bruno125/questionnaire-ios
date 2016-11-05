//
//  QuestionRepo.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 05/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

///Protocol for all those data sources that can provide us a questionnaire
protocol QuestionnaireRepo{
    func getQuestionnaire() -> Observable<Questionnaire>
}
