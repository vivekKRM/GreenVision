//
//  APIService.swift
//  Cleansing
//
//  Created by United It Services on 13/09/23.
//

import Foundation
import Alamofire // You'll need to install Alamofire for network requests if not already installed

class APIService {
    static let shared = APIService() // Singleton instance
    
    private init() {}
    
    func makeAPIRequest(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
