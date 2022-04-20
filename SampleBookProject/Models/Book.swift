//
//  Book.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import Foundation
import ObjectMapper

struct Book: Mappable {
    var title: String?
    var subTitle: String?
    var isbn13: String?
    var price: String?
    var image: String?
    var url: String?
    
    init(title: String?, subTitle: String?, isbn13: String?, price: String?, image: String?, url: String?) {
        self.title = title
        self.subTitle = subTitle
        self.isbn13 = isbn13
        self.price = price
        self.image = image
        self.url = url
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        subTitle <- map["subTitle"]
        isbn13 <- map["isbn13"]
        price <- map["price"]
        image <- map["image"]
        url <- map["url"]
    }
}
