//
//  NumericStatsViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 08/11/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import RxSwift

class NumericStatsViewController: BaseStatisticViewController {

    
    @IBOutlet var averageLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var maxLabel: UILabel!
    @IBOutlet var medianLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var deviationLabel: UILabel!
    
    
    var mViewModel : StatisticNumericViewModel?
    var mDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mViewModel = StatisticNumericViewModel(question: question!, source: Injection.getAnswerRepo())
        bind()
    }
    
    func bind(){
        mViewModel?.getStatsOnce().subscribe(onNext: { stats in
            self.averageLabel.text = stats.average
            self.medianLabel.text = stats.median
            self.modeLabel.text = stats.mode
            self.deviationLabel.text = stats.deviation
            self.minLabel.text = stats.min
            self.maxLabel.text = stats.max
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
