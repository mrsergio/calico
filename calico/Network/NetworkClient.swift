//
//  NetworkClient.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Alamofire
import Combine

struct NetworkClient: NetworkProtocol {
    /// Dispatch Queue used by network to
    private let networkDispatchQueue = DispatchQueue(
        label: "calico.network.background",
        qos: .userInitiated
    )
    
    func fetchByTag(_ tag: String, limit: Int) -> AnyPublisher<[CatModel], AFError> {
        return performRequest([CatModel].self, target: .fetchByTag(tag, limit: limit))
    }
    
    func fetchAvailableTags() -> AnyPublisher<[String], AFError> {
        return performRequest([String].self, target: .fetchAvailableTags)
    }
}

extension NetworkClient {
    
    /// Perform API call
    /// - Parameters:
    ///   - T: type of data we should decode to
    ///   - target: API call from `NetworkAPI`
    /// - Returns: decoded data or error
    private func performRequest<T: Decodable>(_: T.Type, target: NetworkAPI) -> AnyPublisher<T, AFError> {
        let dataRequest: DataRequest = createDataRequest(with: target)
        
        return dataRequest
            .validate()
            .publishDecodable(type: T.self, queue: networkDispatchQueue)
            .value()
            .eraseToAnyPublisher()
    }
    
    /// Creates data request used by Alamofire for a further API call execution
    /// - Parameter target: API call from `NetworkAPI`
    /// - Returns: request used by Alamofire to perform API call
    private func createDataRequest(with target: NetworkAPI) -> DataRequest {
        var url = target.baseURL
        
        if !target.path.isEmpty {
            url = url.appendingPathComponent(target.path)
        }

        switch target.request {
            case .plain:
                return AF.request(url, method: target.method)
                
            case .parameters(let parameters, let encoding):
                return AF.request(url, method: target.method, parameters: parameters, encoding: encoding)
        }
    }
}
