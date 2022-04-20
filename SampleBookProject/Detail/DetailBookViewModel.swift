//
//  DetailBookViewModel.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import UIKit
import RxSwift
import SwiftyJSON
import ObjectMapper

class DetailBookViewModel {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    func isBookmarked(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13 else { return false }
        return BookmarkDAO.shared.findABook(isbn13) != nil
    }
    
    func addBookmark(_ book: Book) -> Bool {
        var books = Global.bookmarks.value
        books.append(book)
        Global.bookmarks.accept(books)
        return BookmarkDAO.shared.addBookmark(book)
    }
    
    func cancelBookmark(_ isbn13: String?) -> Bool {
        var books = Global.bookmarks.value
        if let index = books.firstIndex(where: { $0.isbn13 == isbn13 }) {
            books.remove(at: index)
            Global.bookmarks.accept(books)
        }
        return BookmarkDAO.shared.cancelBookmark(isbn13)
    }
    
    func getBookDetail() -> Single<BookDetail> {
        Single.create { [weak self] observer -> Disposable in
            guard let self = self, let isbn13 = self.book.isbn13 else { return Disposables.create { } }
            
            let onSuccess: (JSON) -> Void = { json in
                guard let bookDetail = Mapper<BookDetail>().map(JSONObject: json.object) else {
                    observer(.failure(NetworkError.badForm))
                    return
                }

                observer(.success(bookDetail))
            }

            let onFailure: (NetworkError) -> Void = { error in
                observer(.failure(error))
            }

            let task = AlamofireWrapper.shared.byGet(url: "1.0/books/\(isbn13)", onSuccess: onSuccess, onFailure: onFailure)
            return Disposables.create { task.cancel() }
        }
    }
}
