//
//  NetworkManager.swift
//  URLSession1111
//
//  Created by Айгерим on 26.08.2024.
//

import Foundation

enum AppConfiguration {
    case one
    case two
    case three
    var url:URL {
        switch self {
            
        case .one:
            return URL(string: "https://swapi.dev/api/people/8")!
        case .two:
            return URL(string:"https://swapi.dev/api/starships/3")!
        case .three:
            return URL(string: "https://swapi.dev/api/planets/5")!
        }
    }
}
enum NetworkError: Error, CustomStringConvertible {
    case notInternet
    case badResponse
    case badStatusCode(Int)
    case noData
    case somethingWrong
    
    var description: String {
        switch self {
            
        case .notInternet:
            return "net Interneta"
        case .badResponse:
            return "net otveta s servera"
        case .badStatusCode(let code):
            return "kod oshibki \(code)"
        case .noData:
            return "net dannyh"
        case .somethingWrong:
            return "shto to poshlo ne tak"
        }
    }
    
}
final class NetworkManager {
   // static let shared = NetworkManager()
    var config: AppConfiguration
    init (config:AppConfiguration) {
        self.config = config
    }
    
    func request(completion: @escaping ((Result<String?, NetworkError>) -> Void)) {
        print("https://api.chucknorris.io/jokes/random")
        
      //  let url = URL(string: "https://api.chucknorris.io/jokes/random")!
        let session = URLSession.shared
        let task = session.dataTask(with: config.url) { data, response, error in
            
            if error != nil {
                completion(.failure(.notInternet))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.badResponse))
                return
            }
            if !(((200..<300)).contains(response.statusCode)) {
                completion(.failure(.badStatusCode(response.statusCode)))
                return
            }
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                guard let answer = try JSONSerialization.jsonObject(with: data) as? [String: Any] else{
                    return
                }
                let joke = answer["name"] as? String
                completion(.success(joke))
            } catch {
                completion(.failure(.somethingWrong))
            
            }
        }
        task.resume()
    }
}
