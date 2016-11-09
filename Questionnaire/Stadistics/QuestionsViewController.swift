//
//  QuestionsViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 07/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class QuestionsViewController: UIViewController {

    let mViewModel = QuestionsViewModel(source: Injection.getQuestionnaireRepo())
    private let mDisposeBag = DisposeBag()
    var mQuestions = [Question]()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Statistics"
        bind()
    }

    func bind(){
        mViewModel.getQuestionsStream()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ q in
                self.mQuestions = q
                self.tableView.reloadData()
            })
            .addDisposableTo(mDisposeBag)
    }
    
    func showQuestionStatistics(question :Question){
        
        //Redirect to proper viewController depending on the question type
        var vc : BaseStatisticViewController?
        switch question.getType() {
        case .text:
            vc = storyboard!.instantiateViewController(withIdentifier: "StatisticTextViewController") as! StatisticTextViewController
            vc?.question = question
            break
        case .numeric:
            vc = storyboard!.instantiateViewController(withIdentifier: "StatisticNumericViewController") as! StatisticNumericViewController
            vc?.question = question
        case .singleOption:
            break
        case .multipleOption:
            break
        default:
            return
        }
        
        //Present view controller if was successfully instantiated
        if vc != nil {
            navigationController?.pushViewController(vc!, animated: true)
        }
        
        
    }
    
}

extension QuestionsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = mQuestions[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)) \(question.title)"
        return cell
    }
}

extension QuestionsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show question statistics
        let question = mQuestions[indexPath.row]
        showQuestionStatistics(question: question)
        
        //Deselect selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
