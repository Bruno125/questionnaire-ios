//
//  QuestionnaireViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Called when user wants to exit. We will ask
    /// for confirmation to proceed with this action
    @IBAction func actionClose(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Exit", message: "If you exit the questionnaire, your answers will not be saved", preferredStyle: UIAlertControllerStyle.alert)
        //Dimiss VC if user accepts
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        //Do nothing if user cancels
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        //Present alert
        present(alert, animated: true, completion: nil)
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
