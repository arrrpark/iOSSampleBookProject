//
//  SearchViewModel.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/20.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import ObjectMapper

protocol SearchBookProtocol: AnyObject {
    var books: [Book] { get set }
    
    var isFetching: Bool { get set }
    var pageIndex: Int { get set }
    var totalPage: Int { get set }
    var word: String { get set }
    
    func searchBooks(_ word: String) -> Single<[Book]>
    func fetchMore() -> Single<[Book]>
    func canFetchMore() -> Bool
}

class SearchBookViewModel: SearchBookProtocol {
    var books: [Book] = []
    
    var isFetching = false
    var pageIndex = 0
    var totalPage = 0
    var word = ""
    
    func searchBooks(_ word: String) -> Single<[Book]> {
        Single.create { observer -> Disposable in
            let onSuccess: (JSON) -> Void = { [weak self] json in
                guard let books = Mapper<Book>().mapArray(JSONObject: json["books"].object) else {
                    observer(.failure(NetworkError.badForm))
                    return
                }
                
                self?.totalPage = json["total"].intValue / 10
                observer(.success(books))
            }
            
            let onFailure: (NetworkError) -> Void = { error in
                observer(.failure(error))
            }
            
            let task = AlamofireWrapper.shared.byGet(url: "1.0/search/\(word)", onSuccess: onSuccess, onFailure: onFailure)
            return Disposables.create { task.cancel() }
        }
    }
    
    func fetchMore() -> Single<[Book]> {
        Single.create { [weak self] observer -> Disposable in
            guard let self = self else {
                observer(.failure(NetworkError.networkError))
                return Disposables.create { }
            }
            
            let onSuccess: (JSON) -> Void = { json in
                guard let books = Mapper<Book>().mapArray(JSONObject: json["books"].object) else {
                    observer(.failure(NetworkError.badForm))
                    return
                }
                
                observer(.success(books))
            }
            
            let onFailure: (NetworkError) -> Void = { error in
                observer(.failure(error))
            }
            
            let task = AlamofireWrapper.shared.byGet(url: "1.0/search/\(self.word)/\(self.pageIndex)", onSuccess: onSuccess, onFailure: onFailure)
            return Disposables.create { task.cancel() }
        }
    }
    
    func canFetchMore() -> Bool {
        return !isFetching && pageIndex < totalPage
    }
}
