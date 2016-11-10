//
//  StatisticsMultipleViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 10/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView
import Charts

class StatisticsMultipleViewController: BaseStatisticViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableLoaderIndicator: NVActivityIndicatorView!
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var chartLoaderIndicator: NVActivityIndicatorView!
    
    
    @IBOutlet var statsWidthConstraint: NSLayoutConstraint!
    @IBOutlet var statsToBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableToTopConstraint: NSLayoutConstraint!
    @IBOutlet var tableLeadingStatsConstraint: NSLayoutConstraint!
    
    
    private var mViewModel : StatisticMultipleViewModel?
    private var mDisposeBag = DisposeBag()
    private var mSorting = MultipleAnswerSorting.value
    var mAnswers = [DisplayableMultipleAnswer]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
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
        
        chartLoaderIndicator.startAnimating()
        chartView.isHidden = true
        //Init viewModel
        mViewModel = StatisticMultipleViewModel(question: question!, source: Injection.getAnswerRepo())
        
        mViewModel?.getAnswersRows(sorting: mSorting)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rows in
                self.mAnswers = rows
                self.tableView.reloadData()
                self.tableLoaderIndicator.stopAnimating()
                self.updateChart()
                self.chartLoaderIndicator.stopAnimating()
            }).addDisposableTo(mDisposeBag)
    }
    
    func setupChart(){
        //Setup loader
        chartLoaderIndicator.type = .lineScale
        chartLoaderIndicator.color = UIColor.white
        
        //Setup chart properties
        chartView.delegate = self
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        //Setup x axis to display labels at bottom
        let xAxis = chartView.xAxis
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor.white
        
        //Hide left and right axis
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
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

extension StatisticsMultipleViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = mAnswers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumericAnswerTableViewCell", for: indexPath) as! NumericAnswerTableViewCell
        cell.valueLabel.text = answer.value
        cell.ocurrencesLabel.text = answer.occurrences
        return cell
    }
    
}

extension StatisticsMultipleViewController : UITableViewDelegate{
    
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

extension StatisticsMultipleViewController : ChartViewDelegate{
    
    func updateChart(){
        
        chartView.xAxis.labelCount = mAnswers.count
        let formatter = BarChartFormatter(values: mAnswers.map( {$0.value} ))
        chartView.xAxis.valueFormatter = formatter
        
        var entries = [BarChartDataEntry]()
        var aux = 0
        for answer in mAnswers {
            entries.append(BarChartDataEntry(x: Double(aux),
                                             y: Double(answer.occurrences)!,
                                             data: answer as AnyObject?))
            aux += 1
        }
        
        let dataSet = BarChartDataSet(values: entries, label: nil)
        dataSet.colors = ChartColorTemplates.liberty()
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10))
        data.barWidth = 0.6
        data.setValueTextColor(UIColor.white)
        
        chartView.data = data
        chartView.isHidden = false
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
}


