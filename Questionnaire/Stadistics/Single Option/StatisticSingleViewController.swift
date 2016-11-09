//
//  StatisticSingleViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class StatisticSingleViewController: BaseStatisticViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableLoaderIndicator: NVActivityIndicatorView!
    
    private var mViewModel : StatisticSingleViewModel?
    private var mDisposeBag = DisposeBag()
    var mSingleAnswers = [DisplayableSingleAnswer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind(){
        //Set question title
        titleLabel.text = question!.title
        //Set loader type
        tableLoaderIndicator.type = .ballPulseSync
        tableLoaderIndicator.color = Utils.appColor()
        tableLoaderIndicator.startAnimating()
        //Init viewModel
        mViewModel = StatisticSingleViewModel(question: question!, source: Injection.getAnswerRepo())
        
        mViewModel?.getAnswersRows()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mSingleAnswers = rows
                self.tableView.reloadData()
                self.tableLoaderIndicator.stopAnimating()
            }).addDisposableTo(mDisposeBag)
    }
    

}


extension StatisticSingleViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSingleAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = mSingleAnswers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleAnswerTableViewCell", for: indexPath) as! SingleAnswerTableViewCell
        cell.valueLabel.text = answer.value
        cell.occurrencesLabel.text = answer.occurrences
        cell.percentageLabel.text = answer.percentage
        return cell
    }
    
}

extension StatisticSingleViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "SingleAnswerHeaderCell") as UIView?
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}
