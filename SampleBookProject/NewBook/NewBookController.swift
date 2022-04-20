//
//  NewBookController.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NewBookController: AppbaseViewController {
    
    let disposeBag = DisposeBag()

    let newBookViewModel: NewBookViewModel
    
    lazy var bookCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var bookCollectionView = NewBookCollectionView(frame: .zero, collectionViewLayout: bookCollectionFlowLayout, newBookViewModel: newBookViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    init(newBookViewModel: NewBookViewModel) {
        self.newBookViewModel = newBookViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newBookViewModel.isFetching = true
        newBookViewModel.getNewBooks().subscribe({ [weak self] event in
            self?.newBookViewModel.isFetching = false
            switch event {
            case .success(let books):
                self?.newBookViewModel.books.append(contentsOf: books)
                self?.bookCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }).disposed(by: disposeBag)
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(bookCollectionView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        bookCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Util.shared.getSafeAreaTopBottom().bottom)
        }
    }
    
}

extension NewBookController: NewBookCollectionViewDelegate {
    func newBookCollectionView(_ collectionView: NewBookCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailBookViewModel = DetailBookViewModel(book: newBookViewModel.books[indexPath.row])
        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
