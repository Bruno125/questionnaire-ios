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
    
}
