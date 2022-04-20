//
//  AlamofireWrapper.swift
//  SampleBookProject
//
//  Created by Arrr Park on 2022/04/17.
//

import Alamofire
import Then
import RxSwift
import ObjectMapper
import SwiftyJSON

enum NetworkError: Error {
    case badForm
    case networkError
}

struct AlamofireWrapper {
    static let shared = AlamofireWrapper()
    
    private init() { }
    
    private let baseUrl = "https://api.itbook.store/"
    
    lazy var headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    func byGet(url: String, parameters: [String: Any]? = nil, onSuccess: ((JSON) -> Void)?, onFailure: ((NetworkError) -> Void)?) -> DataRequest {
        
        return AF.request("\(baseUrl)\(url)", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    guard let data = response.data,
                          let json = try? JSON(data: data) else {
                        onFailure?(.badForm)
                        return
                    }
                    onSuccess?(json)
                case .failure:
                    onFailure?(.networkError)
                }
            }
    }
}
