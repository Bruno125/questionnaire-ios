//
//  QuestionsViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class QuestionsViewController: UIViewController {

    let mViewModel = QuestionsViewModel(source: Injection.getQuestionnaireRepo(),answerRepo: Injection.getAnswerRepo())
    private let mDisposeBag = DisposeBag()
    var mQuestions = [Question]()
    var mSelectedQuestion : Question?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noAnswersLabel: UILabel!
    @IBOutlet var loaderIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Statistics"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bind()
    }

    func bind(){
        //Setup loader
        loaderIndicator.type = .ballPulseSync
        loaderIndicator.startAnimating()
        loaderIndicator.color = Utils.appColor()
        
        self.noAnswersLabel.isHidden = true
        self.tableView.isHidden = true
        
        //Request question
        mViewModel.getQuestionsStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ q in
                self.mQuestions = q
                self.loaderIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
            },onError: { error in
                self.loaderIndicator.stopAnimating()
                self.noAnswersLabel.isHidden = false
            })
            .addDisposableTo(mDisposeBag)
    }
    
    func showQuestionStatistics(question :Question){
        
        //Redirect to proper viewController depending on the question type
        var segue : String?
        switch question.getType() {
        case .text:
            segue = "TextStatisticSegue"
        case .numeric:
            segue = "NumericStatisticSegue"
        case .singleOption:
            segue = "SingleStatisticSegue"
        case .multipleOption:
            segue = "MultipleStatisticSegue"
        default:
            return
        }
        mSelectedQuestion = question
        performSegue(withIdentifier: segue!, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BaseStatisticViewController{
            vc.question = mSelectedQuestion
        }
    }
}

extension QuestionsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = mQuestions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        cell.questionLabel.text = question.title
        cell.typeLabel.text = "#\(question.type)"
        return cell
    }
}

extension QuestionsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show question statistics
        let question = mQuestions[indexPath.row]
        showQuestionStatistics(question: question)
        
        //Deselect selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
