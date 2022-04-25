//
//  BookmarkViewModel.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import Foundation

protocol BookmarkProtocol: AnyObject {
    func findBookmarks() -> [Book]
}

class BookmarkViewModel: BookmarkProtocol {
    func findBookmarks() -> [Book] {
        return BookmarkDAO.shared.findBookmarks()
    }
}
