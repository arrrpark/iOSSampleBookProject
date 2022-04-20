//
//  BookDetail.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import Foundation
import ObjectMapper

struct BookDetail: Mappable {
    var title: String?
    var subTitle: String?
    var authors: String?
    var publisher: String?
    var language: String?
    var isbn10: String?
    var isbn13: String?
    var pages : String?
    var year: String?
    var rating: String?
    var desc: String?
    var price: String?
    var image: String?
    var url: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        subTitle <- map["subTitle"]
        authors <- map["authors"]
        publisher <- map["publisher"]
        language <- map["language"]
        isbn10 <- map["isbn10"]
        isbn13 <- map["isbn13"]
        pages <- map["pages"]
        year <- map["year"]
        rating <- map["rating"]
        desc <- map["desc"]
        price <- map["price"]
        image <- map["image"]
        url <- map["url"]
    }
}
