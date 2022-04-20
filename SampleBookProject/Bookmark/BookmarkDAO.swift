//
//  BookmarkDAO.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/18.
//

import Foundation
import FMDB

class BookmarkDAO {
    
    static let shared = BookmarkDAO()
    
    private lazy var fmdb: FMDatabase = {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        var databasePath = dirPaths[0].appendingPathComponent("bookmark.db").path
        return FMDatabase(path: databasePath)
    }()
    
    private init() {
        fmdb.open()
        createTable()
    }
    
    deinit {
        fmdb.close()
    }
    
    private func createTable() {
        let sql = """
            CREATE TABLE IF NOT EXISTS bookmark (
            isbn13 INTEGER PRIMARY KEY,
            title TEXT,
            subTitle TEXT,
            price TEXT,
            image TEXT,
            url TEXT
            )
        """
        fmdb.executeStatements(sql)
    }
    
    func addBookmark(_ book: Book) -> Bool {
        guard let isbn13 = book.isbn13,
              let number = Int(isbn13) else {
            return false
        }

        let sql = """
            INSERT INTO bookmark (isbn13, title, subtitle, price, image, url)
            VALUES (?, ?, ?, ?, ?, ?)
        """

        do {
            try fmdb.executeUpdate(sql, values: [number,
                                                 book.title ?? "",
                                                 book.subTitle ?? "",
                                                 book.price ?? "",
                                                 book.image ?? "",
                                                 book.url ?? ""])
            return true
        } catch {
            return false
        }
    }
    
    func cancelBookmark(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13, let number = Int(isbn13) else { return false }
        
        do {
            let sql = """
                DELETE FROM bookmark
                WHERE isbn13 = ?
            """
            try fmdb.executeUpdate(sql, values: [number])
            return true
        } catch {
            return false
        }
    }
    
    func findABook(_ isbn13: String?) -> Book? {
        guard let isbn13 = isbn13, let number = Int(isbn13) else { return nil }
        
        let sql = """
            SELECT isbn13, title, subtitle, price, image, url
            FROM bookmark
            WHERE isbn13 = ?
            LIMIT 1
        """
        
        do {
            let rs = try fmdb.executeQuery(sql, values: [number])
            
            rs.next()
            
            guard rs.hasAnotherRow() else { return nil }
            
            let title = rs.string(forColumn: "title")
            let subtitle = rs.string(forColumn: "subtitle")
            let price = rs.string(forColumn: "price")
            let image = rs.string(forColumn: "image")
            let url = rs.string(forColumn: "url")
            
            return Book(title: title, subTitle: subtitle, isbn13: String(isbn13), price: price, image: image, url: url)
        } catch {
            return nil
        }
    }
    
    func findBookmarks() -> [Book] {
        var books: [Book] = []
        
        let sql = """
            SELECT * FROM bookmark
        """
        
        do {
            let rs = try fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                guard rs.hasAnotherRow() else { break }
                
                let title = rs.string(forColumn: "title")
                let subtitle = rs.string(forColumn: "subtitle")
                let price = rs.string(forColumn: "price")
                let isbn13 = rs.string(forColumn: "isbn13")
                let image = rs.string(forColumn: "image")
                let url = rs.string(forColumn: "url")
                
                let book = Book(title: title, subTitle: subtitle, isbn13: isbn13, price: price, image: image, url: url)
                books.append(book)
            }
            return books
        } catch {
            return books
        }
    }
}
