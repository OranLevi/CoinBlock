//
//  NetworkingManger.swift
//  CoinBlock
//
//  Created by Oran Levi on 17/05/2023.
//

import Foundation
import Combine

class NetworkingManger {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url) : return "## Bad response from url: \(url)"
            case .unknown: return "## Unknown error"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw NetworkingError.badURLResponse(url: url)
                }
                return output.data
            }
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: print("## Finished")
        case .failure(let error): print("## Failure \(error)")
        }
    }
}
