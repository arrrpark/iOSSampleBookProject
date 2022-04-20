//
//  Global.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import UIKit
import RxSwift
import RxCocoa

struct Global {
    static var bookmarks = BehaviorRelay<[Book]>(value: BookmarkDAO.shared.findBookmarks())
}
