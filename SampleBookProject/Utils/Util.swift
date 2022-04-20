//
//  Util.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import UIKit

struct Util {
    static let shared = Util()
    
    private init () { }
    
    func getSafeAreaTopBottom() -> (top: CGFloat, bottom: CGFloat) {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        return (safeFrame.minY, window.frame.maxY - safeFrame.maxY)
    }
}
