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
    private var mSorting = TextAnswerSorting.value
    var mTextAnswers = [DisplayableTextAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSortingOptions()
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
        
        mViewModel?.getAnswersRows(sorting:mSorting)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mTextAnswers = rows
                self.tableView.reloadData()
                self.tableLoaderIndicator.stopAnimating()
            }).addDisposableTo(mDisposeBag)
    }
    
    
    func setupSortingOptions(){
        mSorting = .value
        //Create sort button
        let sortButton = UIBarButtonItem(
            image: UIImage(named: "icon_sort"),
            style: .plain,
            target: self,
            action: #selector(showSortAlert))
        //Attach to navigation bar
        self.navigationItem.setRightBarButton(sortButton, animated: true)
    }
    
    func showSortAlert(){
        //Create alert
        let alert = UIAlertController(title: "How should we sort the results?", message: "", preferredStyle: .alert)
        //Add sorting options
        alert.addAction(UIAlertAction(title: "By value", style: .default, handler: {action in self.sortBy(.value)}))
        alert.addAction(UIAlertAction(title: "By occurrences", style: .default, handler: {action in self.sortBy(.occurrences)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //Present alert
        present(alert, animated: true, completion: nil)
    }
    
    func sortBy(_ sorting:TextAnswerSorting){
        mSorting = sorting
        mTextAnswers = mViewModel!.sort(mTextAnswers, by: mSorting)
        tableView.reloadData()
    }

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
