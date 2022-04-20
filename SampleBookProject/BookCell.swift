//
//  BookCell.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import Foundation
import SnapKit
import Then
import UIKit

class BookCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLabel = UILabel()
        .then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    lazy var subTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    lazy var isbn13Label = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    lazy var priceLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(isbn13Label)
        addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(imageView)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        isbn13Label.snp.makeConstraints { make in
            make.leading.equalTo(subTitleLabel)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(3)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(isbn13Label)
            make.top.equalTo(isbn13Label.snp.bottom).offset(3)
        }
    }
}

