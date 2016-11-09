//
//  Utils.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 06/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class Utils: NSObject {

    static func appColor() -> UIColor{
        return UIColor(netHex: 0x002f4d)
    }
    
    
}

extension Int {
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
    
    func times( f: @autoclosure () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}
