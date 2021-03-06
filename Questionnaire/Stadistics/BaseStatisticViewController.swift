//
//  BaseStatisticViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class BaseStatisticViewController: UIViewController {

    var question : Question?
    var requiresQuestionOnLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Exit if question is nil
        if requiresQuestionOnLoad && question == nil {
            dismiss(animated: true, completion: nil)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
