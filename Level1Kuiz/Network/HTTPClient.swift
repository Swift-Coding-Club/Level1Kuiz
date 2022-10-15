//
//  HTTPClient.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/08.
//

import Alamofire
import Foundation

class HTTPClient: ObservableObject {
    private let baseURL = "https://634a6d5f5df952851411457d.mockapi.io/kuiz"

    func request<R: Decodable>(path: String, method: HTTPMethod, completeHandler: @escaping (Result<R, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            fatalError(ServiceConstant.NOT_FOUND_URL)
        }

        AF.request(try! URLRequest(url: url, method: method))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response<R>.self) { response in
                switch response.result {
                case .success(let value):
                    completeHandler(.success(value.data))
                case .failure(let error):
                    completeHandler(.failure(error))
                }
            }
    }
}
