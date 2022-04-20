//
//  AppbaseViewController.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import UIKit
import Then
import SnapKit

class AppbaseViewController: UIViewController {
    lazy var activityIndicator = UIActivityIndicatorView().then {
        $0.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setUpConstraints()
    }
    
    func setupViews() {
        
    }
    
    func setUpConstraints() {
        
    }
}
