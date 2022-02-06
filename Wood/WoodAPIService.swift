//
//  WoodAPIService.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 24.01.2022.
//

import RxSwift
import SwiftUI

enum APIError: Error {
    case invalidURL(String)
    case invalidJSON(String)
    case deleteError
    case getError
    case saveError
}

enum HTTPMethod: String {
    case get = "GET"
    case create = "POST"
    case update = "PUT"
    case delete = "DELETE"
}

enum WoodAPIService {
    static func getEvents<T: Codable>(urlString: String) -> Observable<[T]> {
        let response = Observable.from([urlString])
            .map { urlString -> URL in
                guard let urlString = URL(string: urlString) else { throw APIError.invalidURL(urlString) }
                return urlString
            }
            .map { URLRequest(url: $0) }
            .flatMap { URLSession.shared.rx.response(request: $0) }
            .share(replay: 1)
        
        return response
            .compactMap { response, data -> [T]? in
                switch response.statusCode {
                case 200..<300:
                    do {
                        return try JSONDecoder().decode([T].self, from: data)
                    } catch {
                        throw APIError.invalidJSON("Invalid JSON")
                    }
                default:
                    throw APIError.getError
                }
            }
    }
    
    static func save<T: Codable>(event: T, urlString: String, method: String) -> Observable<HTTPURLResponse> {
        let response = Observable.from([urlString])
            .map { urlString -> URL in
                guard let urlString = URL(string: urlString) else { throw APIError.invalidURL(urlString) }
                return urlString
            }
            .map { url in
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    urlRequest.httpBody = try JSONEncoder().encode(event)
                } catch {
                    throw APIError.invalidJSON("Invalid JSON")
                }
                return urlRequest
            }
            .flatMap { URLSession.shared.rx.response(request: $0) }
            .share(replay: 1)

        return response
            .compactMap { response, _ in
                return response
            }
            .map { response -> HTTPURLResponse in
                switch response.statusCode {
                case 200..<300:
                    return response
                default:
                    throw APIError.saveError
                }
            }
    }
    
    static func deleteEvent(urlString: String) -> Completable {
        return Completable.create { completable in
            _ = Observable.from([urlString])
                .map { urlString -> URL in
                    guard let urlString = URL(string: urlString) else { throw APIError.invalidURL(urlString) }
                    return urlString
                }
                .map { url in
                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = HTTPMethod.delete.rawValue
                    return urlRequest
                }
                .flatMap { URLSession.shared.rx.response(request: $0) }
                .compactMap { response, _ in
                    return response
                }
                .map { response in
                    switch response.statusCode {
                    case 200..<300:
                        completable(.completed)
                    default: completable(.error(APIError.deleteError))
                    }
                }
                .subscribe()
            
            return Disposables.create()
        }
    }
}
