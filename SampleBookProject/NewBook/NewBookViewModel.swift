//
//  NewBookViewModel.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import ObjectMapper

protocol NewBookProtocol: AnyObject {
    var books: [Book] { get set }
    
    func getNewBooks() -> Single<[Book]>
}

class NewBookViewModel: NewBookProtocol {
    var books: [Book] = []
    
    func getNewBooks() -> Single<[Book]> {
        Single.create { observer -> Disposable in
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
            
            let task = AlamofireWrapper.shared.byGet(url: "1.0/new", onSuccess: onSuccess, onFailure: onFailure)
            return Disposables.create { task.cancel() }
        }
    }
}
