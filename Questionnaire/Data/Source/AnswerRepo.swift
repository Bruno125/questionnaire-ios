//
//  AnswerRepo.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

protocol AnswerRepo {
    func save(answers:[Answer]) -> Bool
    func getAll() -> [Answer]
}
