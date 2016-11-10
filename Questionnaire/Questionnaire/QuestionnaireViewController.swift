//
//  QuestionnaireViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import ToastSwiftFramework

class QuestionnaireViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var questionsPageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet var finishView: UIView!
    @IBOutlet var headerToBottomConstraint: NSLayoutConstraint!
    
    var mQuestionnaire : Questionnaire?
    var mViewModel : QuestionnaireViewModel?
    var mCurrentQuestion : Question?
    let mDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if mQuestionnaire == nil{
            //Init viewModel
            mViewModel = QuestionnaireViewModel(
                source: Injection.getQuestionnaireRepo(),
                answerRepo: Injection.getAnswerRepo())
            //Get questionnaire info. The first question will be send as soon as we get the questionnaire
            _ = mViewModel?.startQuestionnaire()
        }else{
            //Init viewModel with a questionnaire
            mViewModel = QuestionnaireViewModel(
                source: Injection.getQuestionnaireRepo(),
                answerRepo: Injection.getAnswerRepo(),
                questionnaire: mQuestionnaire!)
            //Start listening from streams
            bind()
            //We already have a questionnaire, so we request the first question
            mViewModel?.sendNextQuestion()
        }
    }
    
    func bind(){
        
        mViewModel?.getQuestionStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { question in
                self.mCurrentQuestion = question
                self.updateTableView()
            })
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getQuestionnaireStateUpdates()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in self.updateUI(state: state)})
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getErrorStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { msg in self.view.makeToast(msg) })
            .addDisposableTo(mDisposeBag)
        
        mViewModel?.getFinishOnce()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { r in self.finishAnimation() })
            .addDisposableTo(mDisposeBag)
        
    }
    
    func updateUI(state : DisplayableQuestionnaireState){
        self.titleLabel.text = state.question
        
        navigationBar.topItem?.title = state.hint
        questionsPageControl.numberOfPages = state.questionsCount
        questionsPageControl.currentPage = state.currentIndex
        
        //Hide previous button on first question
        let isFirst = state.currentIndex == 0
        previousButton.title = isFirst ? "" : "Previous"
        previousButton.isEnabled = !isFirst
        //Change next button hint to Finish when we are about to finish the questionnaire
        let isLast = state.currentIndex == state.questionsCount - 1
        nextButton.title = isLast ? "Finish" : "Next"
        //Update table selection style depending on current question type
        tableView.allowsSelection = state.questionType == .singleOption
        tableView.allowsMultipleSelection = state.questionType == .multipleOption
        
    }
    
    func finishAnimation(){
        headerToBottomConstraint.priority = 900
        //Expand header and hide other views
        UIView.animate(withDuration: 0.5, animations: {
            self.questionsPageControl.alpha = 0
            self.titleLabel.alpha = 0
            self.navigationBar.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (value: Bool) in
            //Show finish view
            UIView.animate(withDuration: 0.3, animations: {
                self.finishView.alpha = 1
            }, completion: { (value:Bool) in
                //Wait a few seconds and dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.modalTransitionStyle = .crossDissolve
                    self.dismiss(animated: true, completion: nil)
                })
            })
        })
        
    }
    
    
    func updateTableView(){
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func actionNext(_ sender: Any) {
        mViewModel?.sendNextQuestion()
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        mViewModel?.sendPreviousQuestion()
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

}

extension QuestionnaireViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCurrentQuestion == nil ? 0 : mCurrentQuestion!.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Instantiate proper cell depending on question type
        let cell : UITableViewCell
        switch mCurrentQuestion!.getType() {
        case .text:
            cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath)
        case .numeric:
            cell = tableView.dequeueReusableCell(withIdentifier: "NumericTableViewCell", for: indexPath)
        case .singleOption, .multipleOption:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath)
            cell.accessoryType = .none
        default:
            cell = UITableViewCell()
        }
        //If cell and bind data from choice
        if let choiceCell = cell as? ChoiceCell{
            let choice = mCurrentQuestion!.choices[indexPath.row]
            choiceCell.setData(choice: choice!)
        }
        
        return cell
    }
}

extension QuestionnaireViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
    }
    
}


