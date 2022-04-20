//
//  UIButton+Extension.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import UIKit

extension UIButton {
    @discardableResult
    func setImageButton(_ image: UIImage?) -> UIButton {
        setImage(image, for: .normal)
        tintColor = .black
        imageView?.contentMode = .scaleAspectFit
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        return self
    }
}
