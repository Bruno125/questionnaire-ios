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

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var questionsPageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    var mQuestionnaire : Questionnaire?
    var mViewModel : QuestionnaireViewModel?
    let mDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mQuestionnaire == nil{
            //Init viewModel
            mViewModel = QuestionnaireViewModel(source: Injection.getQuestionnaireRepo())
            //Get questionnaire info. The first question will be send as soon as we get the questionnaire
            _ = mViewModel?.startQuestionnaire()
        }else{
            //Init viewModel with a questionnaire
            mViewModel = QuestionnaireViewModel(source: Injection.getQuestionnaireRepo(), questionnaire: mQuestionnaire!)
            //Start listening from streams
            bind()
            //We already have a questionnaire, so we request the first question
            mViewModel?.sendNextQuestion()
        }
    }
    
    func bind(){
        
        mViewModel?.getTextQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in
            })
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getNumberQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in
            })
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getSingleOptionQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in
            })
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getMultipleOptionQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { q in
            })
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getQuestionnaireStateUpdates()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in self.updateUI(state: state)})
            .addDisposableTo(mDisposeBag)
    }
    
    func updateUI(state : DisplayableQuestionnaireState){
        self.titleLabel.text = state.question
        
        navigationBar.topItem?.title = state.hint
        questionsPageControl.numberOfPages = state.questionsCount
        questionsPageControl.currentPage = state.currentIndex
    }
    
    
    @IBAction func actionNext(_ sender: Any) {
        mViewModel?.sendNextQuestion()
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        mViewModel?.sendPrevioustQuestion()
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
