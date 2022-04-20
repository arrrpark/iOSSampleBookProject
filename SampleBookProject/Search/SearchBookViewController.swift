//
//  SearchBookController.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/20.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class SearchBookViewController: AppbaseViewController {
    let disposeBag = DisposeBag()
    
    let searchBookViewModel: SearchBookViewModel
    
    lazy var searchTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    lazy var searchButton = UIButton().then {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .lightGray
        $0.rx.tap.bind { [weak self] in
            guard let self = self,
                  let word = self.searchTextField.text,
                  !word.isEmpty else {
                return
            }
            
            self.showIndicator()
            self.searchBookViewModel.searchBooks(word).subscribe({ [weak self] event in
                self?.hideIndicator()
                switch event {
                case .success(let books):
                    self?.searchBookViewModel.books = books
                    self?.searchBookViewModel.pageIndex = 1
                    self?.searchBookViewModel.word = word
                    self?.searchBookCollectionView.reloadData()
                case .failure:
                    break
                }
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    lazy var searchBookCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var searchBookCollectionView = SearchBookCollectionView(frame: .zero, collectionViewLayout: searchBookCollectionFlowLayout, searchBookViewModel: searchBookViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    init(searchBookViewModel: SearchBookViewModel) {
        self.searchBookViewModel = searchBookViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(searchBookCollectionView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.trailing.equalTo(searchButton.snp.leading).offset(-20)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.height.equalTo(searchTextField)
            make.width.equalTo(70)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        searchBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Util.shared.getSafeAreaTopBottom().bottom)
        }
    }
}

extension SearchBookViewController: SearchBookCollectionViewDelegate {
    func searchBookCollectionView(_ collectionView: SearchBookCollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == searchBookViewModel.books.count - 1,
           searchBookViewModel.canFetchMore() {
            searchBookViewModel.isFetching = true
            showIndicator()
            searchBookViewModel.fetchMore().subscribe({ [weak self] event in
                self?.searchBookViewModel.isFetching = false
                self?.hideIndicator()
                switch event {
                case .success(let books):
                    self?.searchBookViewModel.books.append(contentsOf: books)
                    self?.searchBookViewModel.pageIndex += 1
                    self?.searchBookCollectionView.reloadData()
                case .failure:
                    break
                }
            }).disposed(by: disposeBag)
        }
    }
    
    func searchBookCollectionView(_ collectionView: SearchBookCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailBookViewModel = DetailBookViewModel(book: searchBookViewModel.books[indexPath.row])
        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
