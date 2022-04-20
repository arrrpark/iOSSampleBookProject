//
//  BookmarkViewModel.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import Foundation

class BookmarkViewModel {
    func findBookmarks() -> [Book] {
        return BookmarkDAO.shared.findBookmarks()
    }
}
