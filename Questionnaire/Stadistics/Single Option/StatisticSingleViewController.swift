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
import Charts

class StatisticSingleViewController: BaseStatisticViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableLoaderIndicator: NVActivityIndicatorView!
    @IBOutlet var chartView: PieChartView!
    @IBOutlet var chartLoaderIndicator: NVActivityIndicatorView!
    
    private var mViewModel : StatisticSingleViewModel?
    private var mDisposeBag = DisposeBag()
    private var mSorting = SingleAnswerSorting.value
    var mSingleAnswers = [DisplayableSingleAnswer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSortingOptions()
        setupChart()
        bind()
    }
    
    func bind(){
        //Set question title
        titleLabel.text = question!.title
        //Set loader type
        tableLoaderIndicator.type = .ballPulseSync
        tableLoaderIndicator.color = Utils.appColor()
        tableLoaderIndicator.startAnimating()
        
        chartLoaderIndicator.type = .lineScale
        chartLoaderIndicator.color = UIColor.white
        chartLoaderIndicator.startAnimating()
        chartView.isHidden = true
        //Init viewModel
        mViewModel = StatisticSingleViewModel(question: question!, source: Injection.getAnswerRepo())
        
        mViewModel?.getAnswersRows(sorting: mSorting)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mSingleAnswers = rows
                self.tableView.reloadData()
                self.tableLoaderIndicator.stopAnimating()
                self.updateChart()
                self.chartLoaderIndicator.stopAnimating()
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
    
    func setupChart(){
        chartView.delegate = self
        chartView.entryLabelColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        chartView.legend.enabled = false
        chartView.holeRadiusPercent = 0.2
        chartView.transparentCircleRadiusPercent = 0.2
        chartView.drawCenterTextEnabled = false
        chartView.chartDescription?.enabled = false
    }
    
    func showSortAlert(){
        //Create alert
        let alert = UIAlertController(title: "How should we sort the results?", message: "", preferredStyle: .alert)
        //Add sorting options
        alert.addAction(UIAlertAction(title: "By value", style: .default, handler: {action in self.sortBy(.value)}))
        alert.addAction(UIAlertAction(title: "By occurrences", style: .default, handler: {action in self.sortBy(.occurrences)}))
        alert.addAction(UIAlertAction(title: "By percentage", style: .default, handler: {action in self.sortBy(.percentage)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //Present alert
        present(alert, animated: true, completion: nil)
    }
    
    func sortBy(_ sorting:SingleAnswerSorting){
        mSorting = sorting
        mSingleAnswers = mViewModel!.sort(mSingleAnswers, by: mSorting)
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chartView.highlightValue(x: Double(indexPath.row), dataSetIndex: 0, callDelegate: true)
    }
    
}


extension StatisticSingleViewController : ChartViewDelegate{
    
    func updateChart(){
        
        //Create entries
        var entries = [PieChartDataEntry]()
        for answer in mSingleAnswers{
            entries.append(PieChartDataEntry(value: answer.percentageValue, label: answer.value, data: answer as AnyObject?))
        }
        //Create data set for chart
        let dataSet = PieChartDataSet(values: entries, label: nil)
        dataSet.sliceSpace = 2.0
        //Set color palette
        let colors = ChartColorTemplates.liberty()
        dataSet.colors = colors
        //Create data
        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0))
        chartView.data = data
        chartView.isHidden = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        var index = 0, aux = 0
        for answer in mSingleAnswers{
            if let selected = entry.data as? DisplayableSingleAnswer{
                if answer.value == selected.value{
                    index = aux
                }
            }
            aux += 1
        }
        //Select table row
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        tableView.reloadData()
    }
    
}

