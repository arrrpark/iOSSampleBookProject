//
//  ViewController+Extension.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/20.
//

import UIKit
import Then
import SnapKit

extension AppbaseViewController {
    func showIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func hideIndicator() {
        activityIndicator.removeFromSuperview()
    }
}
