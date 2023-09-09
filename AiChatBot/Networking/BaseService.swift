//
//  BaseService.swift
//  AiChatBot
//
//  Created by Irtaza Fiaz on 08/09/2023.
//

import Foundation
import Combine
import Alamofire

class BaseService: BaseActions {
    
    private init() {}
    static let shared = BaseService()
    
    private let baseAPIUrl = "http://127.0.0.1:5000/"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utilities.jsonDecoder
    
    func loadAndDecode<D: Decodable>(
        url: URL,
        params: [String: String],
        method: HTTPMethod = .post ,
        completion: @escaping (Result<D, ApiError>) -> ()) {
            
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            if let refreshToken = params["refresh_token"] {
                headers["Authorization"] = "Bearer \(refreshToken)"
            }
            var p = params
            if method == .get {
                p = [:]
            }
            AF.request(url, method: method, parameters: p, encoding: method == .get ? URLEncoding.default : JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value)
                            let decodedResponse = try Utilities.jsonDecoder.decode(D.self, from: jsonData)
                            completion(.success(decodedResponse))
                        } catch {
                            print("Error while decoding: \(error)")
                            completion(.failure(.serializationError))
                        }
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        if let data = response.data {
                            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                        }
                        completion(.failure(.apiError))
                    }
                }
            
        }
    
    
    func executeCompletionHandlerInMainThread<D: Decodable>(
        with result: Result<D, ApiError>,
        completion: @escaping (Result<D, ApiError>) -> ()) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
    
    func registerUser(from movieEndPoint: ApiServiceEndPoint, params: [String: String], completion: @escaping (Result<RegisterResponse, ApiError>) -> ()) {
        guard let url = URL(string: "\(baseAPIUrl)\(movieEndPoint.rawValue)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
        self.loadAndDecode(url: url, params: params, completion: completion)
    }
    
    func login(from movieEndPoint: ApiServiceEndPoint, params: [String: String], completion: @escaping (Result<LoginResponse, ApiError>) -> ()) {
        guard let url = URL(string: "\(baseAPIUrl)\(movieEndPoint.rawValue)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
        self.loadAndDecode(url: url, params: params, completion: completion)
    }
    
    func logout(from movieEndPoint: ApiServiceEndPoint, refreshToken: String, completion: @escaping (Result<RegisterResponse, ApiError>) -> ()) {
        guard let url = URL(string: "\(baseAPIUrl)\(movieEndPoint.rawValue)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
        self.loadAndDecode(url: url, params: ["refresh_token": refreshToken], method: .get, completion: completion)
    }

    
}
