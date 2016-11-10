//
//  NumericGraphViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import NVActivityIndicatorView

class NumericGraphViewController: BaseStatisticViewController {
    
    @IBOutlet var chartView: BarChartView!
    @IBOutlet var indicatorView: NVActivityIndicatorView!
    
    private var mViewModel : StatisticNumericViewModel?
    private var mDisposeBag = DisposeBag()
    var mAnswers = [DisplayableNumericAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mViewModel = StatisticNumericViewModel(question: question!, source: Injection.getAnswerRepo())
        setup()
        bind()
    }
    
    func setup(){
        //Setup loader
        indicatorView.type = .lineScale
        indicatorView.color = UIColor.white
        
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
    
    func bind(){
        chartView.isHidden = true
        indicatorView.startAnimating()
        mViewModel?.getAnswersRows().subscribe(onNext: { answers in
            self.mAnswers = answers
            self.updateChart()
            self.chartView.isHidden = false
            self.indicatorView.stopAnimating()
        }).addDisposableTo(mDisposeBag)
    }
}

extension NumericGraphViewController : ChartViewDelegate{
    
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
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
}

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    private var values = [String]()
    
    init(values: [String]) {
        self.values = values
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return values[Int(value)]
    }
}
