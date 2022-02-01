//
//  NetworkService.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 24.01.2022.
//

import RxSwift

enum NetworkService {
    static func getEvents<T: Codable>(urlString: String) -> Observable<[T]> {
        let response = Observable.from([urlString])
            .map { urlString -> URL in
                guard let urlString = URL(string: urlString) else { fatalError("Bad URL") }
                return urlString
            }
            .map { URLRequest(url: $0) }
        //            .map { url in
        //                var urlRequest = URLRequest(url: url)
        //                urlRequest.httpMethod = "GET"
        //                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //                urlRequest.httpBody = nil
        //                return urlRequest
        //            }
            .flatMap { URLSession.shared.rx.response(request: $0) }
            .share(replay: 1)
        
        return response
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .compactMap { _, data -> [T]? in
                print(data)
                return try? JSONDecoder().decode([T].self, from: data)
            }
    }
    
    static func save<T: Codable>(event: T, urlString: String, method: String) -> Observable<HTTPURLResponse> {
        let response = Observable.from([urlString])
            .map { urlString -> URL in
                guard let urlString = URL(string: urlString) else { fatalError("Bad URL") }
                return urlString
            }
            .map { url in
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try? JSONEncoder().encode(event)
                return urlRequest
            }
            .flatMap { URLSession.shared.rx.response(request: $0) }
            .share(replay: 1)
        
        return response
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .compactMap { response, _ in
                return response
            }
    }
    
    static func deleteEvent(urlString: String) -> Observable<HTTPURLResponse> {
        let response = Observable.from([urlString])
            .map { urlString -> URL in
                guard let urlString = URL(string: urlString) else { fatalError("Bad URL") }
                return urlString
            }
            .map { url in
                var urlRequest = URLRequest(url: url)
//                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpMethod = "DELETE"
                return urlRequest
            }
            .flatMap { URLSession.shared.rx.response(request: $0) }
            .share(replay: 1)
        
        return response
            .filter { response, _ in
                print(response.statusCode)
                return 200..<300 ~= response.statusCode
            }
            .compactMap { response, _ in
                return response
            }
    }
}
