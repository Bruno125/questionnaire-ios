//
//  QuestionnaireViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class QuestionnaireViewController: UIViewController {

    let mViewModel = QuestionnaireViewModel(source: Injection.getQuestionnaireRepo())
    let mDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func bind(){
        
        mViewModel.getTextQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in print(q)})
            .addDisposableTo(mDisposeBag)
        
        mViewModel.getNumberQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in print(q)})
            .addDisposableTo(mDisposeBag)
        
        mViewModel.getSingleOptionQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in print(q)})
            .addDisposableTo(mDisposeBag)
        
        mViewModel.getMultipleOptionQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in print(q)})
            .addDisposableTo(mDisposeBag)
        
        mViewModel.startQuestionnaire()
        
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
