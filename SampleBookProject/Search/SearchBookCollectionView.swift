//
//  SearchCollectionView.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/20.
//

import UIKit
import Kingfisher

protocol SearchBookCollectionViewDelegate: AnyObject {
    func searchBookCollectionView(_ collectionView: SearchBookCollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func searchBookCollectionView(_ collectionView: SearchBookCollectionView, didSelectItemAt indexPath: IndexPath)
}

class SearchBookCollectionView: UICollectionView {
    weak var viewDelegate: SearchBookCollectionViewDelegate?
    
    let searchBookViewModel: SearchBookProtocol
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, searchBookViewModel: SearchBookProtocol) {
        self.searchBookViewModel = searchBookViewModel
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(BookCell.self, forCellWithReuseIdentifier: String(describing: BookCell.self))
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchBookCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewDelegate?.searchBookCollectionView(self, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.searchBookCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension SearchBookCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchBookViewModel.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        let data = searchBookViewModel.books[indexPath.row]
        
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

extension SearchBookCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}
