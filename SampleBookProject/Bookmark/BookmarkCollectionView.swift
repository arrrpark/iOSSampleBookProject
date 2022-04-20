//
//  BookmarkCollectionView.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import UIKit
import Kingfisher

protocol BookmarkCollectionViewDelegate: AnyObject {
    func bookmarkCollectionView(_ collectionView: BookmarkCollectionView, didSelectItemAt indexPath: IndexPath)
}

class BookmarkCollectionView: UICollectionView {
    weak var viewDelegate: BookmarkCollectionViewDelegate?
    
    let bookmarkViewModel: BookmarkViewModel
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, bookmarkViewModel: BookmarkViewModel) {
        self.bookmarkViewModel = bookmarkViewModel
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(BookCell.self, forCellWithReuseIdentifier: String(describing: BookCell.self))
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.bookmarkCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension BookmarkCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Global.bookmarks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        let data = Global.bookmarks.value[indexPath.row]
        
        if let urlString = data.image, let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let image):
                    cell.imageView.image = image.image
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        cell.titleLabel.text = data.title
        cell.subTitleLabel.text = data.subTitle
        cell.isbn13Label.text = data.isbn13
        cell.priceLabel.text = data.price
        
        return cell
    }
}

extension BookmarkCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}
