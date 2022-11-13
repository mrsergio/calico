//
//  NetworkAPI.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Alamofire

enum NetworkAPI {
    case fetchByTag(_ tag: String, limit: Int)
    case fetchAvailableTags
    
    static let url = URL(string: "https://cataas.com/")!
}

enum RequestTask {
    case plain
    case parameters(parameters: [String: Any], encoding: ParameterEncoding)
}

extension NetworkAPI {
    
    var baseURL: URL {
        NetworkAPI.url.appendingPathComponent("api")
    }
    
    var path: String {
        switch self {
            case .fetchByTag:
                return "cats"
                
            case .fetchAvailableTags:
                return "tags"
        }
    }
    
    var method: HTTPMethod {
        HTTPMethod.get
    }
    
    var request: RequestTask {
        switch self {
            case .fetchByTag(let tag, let limit):
                return .parameters(
                    parameters: [
                        "tags": tag,
                        "limit": limit
                    ],
                    encoding: URLEncoding.default
                )
                
            case .fetchAvailableTags:
                return .plain
        }
    }
}
