//
//  BookmarkViewController.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import UIKit
import RxSwift
import RxCocoa

class BookmarkViewController: AppbaseViewController {
    let disposeBag = DisposeBag()
    
    let bookmarkViewModel: BookmarkViewModel
    
    lazy var bookmarkCollectinViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var bookmarkCollectionView = BookmarkCollectionView(frame: .zero, collectionViewLayout: bookmarkCollectinViewFlowLayout, bookmarkViewModel: bookmarkViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    init(bookmarkViewModel: BookmarkViewModel) {
        self.bookmarkViewModel = bookmarkViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.bookmarks.asDriver().drive(onNext: { [weak self] _ in
            self?.bookmarkCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(bookmarkCollectionView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        bookmarkCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Util.shared.getSafeAreaTopBottom().bottom)
        }
    }
}

extension BookmarkViewController: BookmarkCollectionViewDelegate {
    func bookmarkCollectionView(_ collectionView: BookmarkCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailBookViewModel = DetailBookViewModel(book: Global.bookmarks.value[indexPath.row])
        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
