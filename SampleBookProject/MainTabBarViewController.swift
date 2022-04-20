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
    
    lazy var newBookViewCnotroller = NewBookViewController(newBookViewModel: NewBookViewModel()).then {
        $0.tabBarItem = UITabBarItem(title: "New", image: nil, tag: 0)
    }
    
    lazy var searchViewcontroller = SearchBookViewController(searchBookViewModel: SearchBookViewModel()).then {
        $0.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 1)
    }
    
    lazy var bookmarkViewController = BookmarkViewController(bookmarkViewModel: BookmarkViewModel()).then {
        $0.tabBarItem = UITabBarItem(title: "Bookmark", image: nil, tag: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        viewControllers = [newBookViewCnotroller, searchViewcontroller, bookmarkViewController]
    }
}

