//
//  FirstViewController.swift
//  Questionnaire
//
//  Created by Bruno Aybar on 26/10/2016.
//  Copyright © 2016 Bruno Aybar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift

class FirstViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    
    let mDisposeBag = DisposeBag()
    var mQuestionnaire : Questionnaire?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicatorView.type = .ballTrianglePath
        loadingIndicatorView.color = Utils.appColor()
        loadingIndicatorView.startAnimating()
        
        bind()
    }

    func bind(){
        Injection.getQuestionnaireRepo().getQuestionnaire()
            .subscribe(onNext: { questionnaire in
                self.mQuestionnaire = questionnaire
                self.bindContent()
            }).addDisposableTo(mDisposeBag)
    }
    
    func bindContent(){
        if mQuestionnaire != nil{
            infoView.isHidden = false
            loadingIndicatorView.stopAnimating()
            titleLabel.text = mQuestionnaire!.title
            descriptionLabel.text = mQuestionnaire!.description
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

