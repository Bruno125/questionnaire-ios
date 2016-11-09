//
//  StatisticNumericViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class StatisticNumericViewController: BaseStatisticViewController {
    
    @IBOutlet var statsContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private var mViewModel : StatisticNumericViewModel?
    private var mDisposeBag = DisposeBag()
    var mNumericAnswers = [DisplayableNumericAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind(){
        //Set question title
        titleLabel.text = question!.title
        //Init viewModel
        mViewModel = StatisticNumericViewModel(question: question!, source: Injection.getAnswerRepo())
        
        mViewModel?.getAnswersRows()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mNumericAnswers = rows
                self.tableView.reloadData()
            }).addDisposableTo(mDisposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil {
            return
        }
        
        switch segue.identifier! {
        case "StatsContainerSegue":
            (segue.destination as? StatisticNumericPageViewController)?.question = question
        default:
            break
        }
    }
}


extension StatisticNumericViewController : UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mNumericAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = mNumericAnswers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumericAnswerTableViewCell", for: indexPath) as! NumericAnswerTableViewCell
        cell.valueLabel.text = answer.value
        cell.ocurrencesLabel.text = answer.occurrences
        return cell
    }
    
}

extension StatisticNumericViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "NumericAnswerHeaderCell") as UIView?
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}

