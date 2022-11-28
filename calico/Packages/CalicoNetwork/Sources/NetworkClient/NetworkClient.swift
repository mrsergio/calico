//
//  NetworkClient.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Alamofire
import Combine

public struct NetworkClient: NetworkProtocol {
    
    public init() { }

    public func fetchByTag<T: Decodable>(_: T.Type, tag: String, limit: Int) async throws -> T {
        return try await performRequest(T.self, target: .fetchByTag(tag, limit: limit))
    }
    
    public func fetchAvailableTags() async throws -> [String] {
        return try await performRequest([String].self, target: .fetchAvailableTags)
    }
}

private extension NetworkClient {
    
    /// Perform API call
    /// - Parameters:
    ///   - T: type of data we should decode to
    ///   - target: API call from `NetworkAPI`
    /// - Returns: decoded data or error
    private func performRequest<T: Decodable>(_: T.Type, target: NetworkAPI) async throws -> T {
        let dataRequest: DataRequest = createDataRequest(with: target)
        
        return try await dataRequest
            .validate()
            .serializingDecodable(T.self)
            .value
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
