//
//  StatisticNumericViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class StatisticNumericViewController: BaseStatisticViewController {
    
    @IBOutlet var statsContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableLoaderIndicator: NVActivityIndicatorView!
    
    
    @IBOutlet var statsWidthConstraint: NSLayoutConstraint!
    @IBOutlet var statsToBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableToTopConstraint: NSLayoutConstraint!
    @IBOutlet var tableLeadingStatsConstraint: NSLayoutConstraint!
    
    
    private var mViewModel : StatisticNumericViewModel?
    private var mDisposeBag = DisposeBag()
    private var mSorting = NumericAnswerSorting.valueAscending
    var mNumericAnswers = [DisplayableNumericAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSortingOptions()
        updateConstraints()
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
        mViewModel = StatisticNumericViewModel(question: question!, source: Injection.getAnswerRepo())
        
        mViewModel?.getAnswersRows(sorting: mSorting)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mNumericAnswers = rows
                self.tableView.reloadData()
                self.tableLoaderIndicator.stopAnimating()
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
    
    func setupSortingOptions(){
        mSorting = .valueAscending
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
        alert.addAction(UIAlertAction(title: "By value ascending", style: .default,
                                      handler: {action in self.sortBy(.valueAscending)}))
        alert.addAction(UIAlertAction(title: "By value descending", style: .default,
                                      handler: {action in self.sortBy(.valueDescending)}))
        alert.addAction(UIAlertAction(title: "By occurrences ascending", style: .default,
                                      handler: {action in self.sortBy(.occurrencesAscending)}))
        alert.addAction(UIAlertAction(title: "By occurrences desscending", style: .default,
                                      handler: {action in self.sortBy(.occurrencesDescending)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //Present alert
        present(alert, animated: true, completion: nil)
    }
    
    func sortBy(_ sorting:NumericAnswerSorting){
        mSorting = sorting
        mNumericAnswers = mViewModel!.sort(mNumericAnswers, by: mSorting)
        tableView.reloadData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateConstraints()
    }
    
    func updateConstraints(){
        let isLandscape = UIDevice.current.orientation.isLandscape
        let priority = UILayoutPriority(isLandscape ? 900 : 100)
        statsWidthConstraint.priority = priority
        statsToBottomConstraint.priority = priority
        tableToTopConstraint.priority = priority
        tableLeadingStatsConstraint.priority = priority
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

