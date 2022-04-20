//
//  DetailBookViewController.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import UIKit
import SnapKit
import Kingfisher
import Then
import RxSwift
import RxCocoa

class DetailBookViewController: AppbaseViewController {
    
    let disposeBag = DisposeBag()
    
    let detailBookViewModel: DetailBookViewModel
    
    lazy var optionBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var backButton = UIButton().setImageButton(UIImage(systemName: "arrow.left")).then {
        $0.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
    
    lazy var bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    lazy var subTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var authorsLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var publisherLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var languageLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var isbn10Label = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var isbn13Label = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var pagesLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var yearLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var descLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 0
    }
    
    lazy var priceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var bookmarkButton = UIButton().then {
        $0.setTitle("Bookmark", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
        $0.isHidden = true
        
        $0.rx.tap.bind { [weak self] in
            self?.onBookmarkPressed()
        }.disposed(by: disposeBag)
    }
    
    init(detailBookViewModel: DetailBookViewModel) {
        self.detailBookViewModel = detailBookViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailBookViewModel.getBookDetail().subscribe({ [weak self] event in
            switch event {
            case .success(let detail):
                if let urlString = detail.image, let url = URL(string: urlString) {
                    let resource = ImageResource(downloadURL: url)
                    KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
                        switch result {
                        case .success(let value):
                            self?.bookImageView.image = value.image
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
                self?.titleLabel.text = detail.title
                self?.subTitleLabel.text = detail.subTitle
                self?.authorsLabel.text = detail.authors
                self?.publisherLabel.text = detail.publisher
                self?.languageLabel.text = detail.language
                if let isbn10 = detail.isbn10 { self?.isbn10Label.text = "isbn10 : \(isbn10)" }
                if let isbn13 = detail.isbn13 { self?.isbn13Label.text = "isbn13 : \(isbn13)" }
                if let pages = detail.pages { self?.pagesLabel.text = "pages : \(pages)" }
                if let year = detail.year { self?.yearLabel.text = "year : \(year)" }
                self?.descLabel.text = detail.desc
                if let price = detail.price { self?.priceLabel.text = "price : \(price)" }
                self?.bookmarkButton.isHidden = false
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
        
        if detailBookViewModel.isBookmarked(detailBookViewModel.book.isbn13) {
            bookmarkButton.setTitle("Cancel bookmark", for: .normal)
        } else {
            bookmarkButton.setTitle("Bookmark", for: .normal)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(optionBar)
        optionBar.addSubview(backButton)
        
        view.addSubview(bookImageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(authorsLabel)
        view.addSubview(publisherLabel)
        view.addSubview(languageLabel)
        view.addSubview(isbn10Label)
        view.addSubview(isbn13Label)
        view.addSubview(pagesLabel)
        view.addSubview(yearLabel)
        view.addSubview(descLabel)
        view.addSubview(priceLabel)
        view.addSubview(bookmarkButton)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        optionBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(optionBar.snp.bottom).offset(10)
            make.size.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(bookImageView.snp.bottom).offset(5)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        authorsLabel.snp.makeConstraints { make in
            make.leading.equalTo(subTitleLabel)
            make.trailing.equalTo(subTitleLabel)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorsLabel)
            make.trailing.equalTo(authorsLabel)
            make.top.equalTo(authorsLabel.snp.bottom).offset(5)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.leading.equalTo(publisherLabel)
            make.trailing.equalTo(publisherLabel)
            make.top.equalTo(publisherLabel.snp.bottom).offset(5)
        }
        
        isbn10Label.snp.makeConstraints { make in
            make.leading.equalTo(languageLabel)
            make.trailing.equalTo(languageLabel)
            make.top.equalTo(languageLabel.snp.bottom).offset(5)
        }
        
        isbn13Label.snp.makeConstraints { make in
            make.leading.equalTo(isbn10Label)
            make.trailing.equalTo(isbn10Label)
            make.top.equalTo(isbn10Label.snp.bottom).offset(5)
        }
        
        pagesLabel.snp.makeConstraints { make in
            make.leading.equalTo(isbn13Label)
            make.trailing.equalTo(isbn13Label)
            make.top.equalTo(isbn13Label.snp.bottom).offset(5)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.leading.equalTo(pagesLabel)
            make.trailing.equalTo(pagesLabel)
            make.top.equalTo(pagesLabel.snp.bottom).offset(5)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(yearLabel)
            make.trailing.equalTo(yearLabel)
            make.top.equalTo(yearLabel.snp.bottom).offset(5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(descLabel)
            make.trailing.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(5)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
        }
    }
    
    private func onBookmarkPressed() {
        if detailBookViewModel.isBookmarked(detailBookViewModel.book.isbn13) {
            if detailBookViewModel.cancelBookmark(detailBookViewModel.book.isbn13) {
                bookmarkButton.setTitle("Bookmark", for: .normal)
            }
        } else {
            if detailBookViewModel.addBookmark(detailBookViewModel.book) {
                bookmarkButton.setTitle("Cancel bookmark", for: .normal)
            }
        }
    }
}
