//
//  StatisticTextViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 09/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class StatisticTextViewController: BaseStatisticViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableLoaderIndicator: NVActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    private var mViewModel : StatisticTextViewModel?
    private var mDisposeBag = DisposeBag()
    var mTextAnswers = [DisplayableTextAnswer]()
    
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
        mViewModel = StatisticTextViewModel(question: question!, source: Injection.getAnswerRepo())
        
        mViewModel?.getAnswersRows()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mTextAnswers = rows
                self.tableView.reloadData()
                self.tableLoaderIndicator.stopAnimating()
            }).addDisposableTo(mDisposeBag)
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



extension StatisticTextViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTextAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = mTextAnswers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextAnswerTableViewCell", for: indexPath) as! TextAnswerTableViewCell
        cell.valueLabel.text = answer.value
        cell.occurrencesLabel.text = answer.occurrences
        return cell
    }
    
}

extension StatisticTextViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "TextAnswerHeaderCell") as UIView?
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}
