//
//  ViewController.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MainTabBarViewController: UITabBarController {
    
    lazy var newBookCnotroller = NewBookController(newBookViewModel: NewBookViewModel()).then {
        $0.tabBarItem = UITabBarItem(title: "New", image: nil, tag: 0)
    }
    
    lazy var bookmarkViewController = BookmarkViewController(bookmarkViewModel: BookmarkViewModel()).then {
        $0.tabBarItem = UITabBarItem(title: "Bookmark", image: nil, tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [newBookCnotroller, bookmarkViewController]
    }
}

