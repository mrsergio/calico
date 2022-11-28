//
//  NetworkAPI.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Alamofire

public enum NetworkAPI {
    case fetchByTag(_ tag: String, limit: Int)
    case fetchAvailableTags
    
    public static let url = URL(string: "https://cataas.com/")!
}

enum RequestType {
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
    
    var request: RequestType {
        switch self {
            case .fetchByTag(let tag, let limit):
                var params: [String: Any] = [
                    "tags": tag
                ]
                
                if limit > 0 {
                    params["limit"] = limit
                }
                
                return .parameters(
                    parameters: params,
                    encoding: URLEncoding.default
                )
                
            case .fetchAvailableTags:
                return .plain
        }
    }
}
