//
//  NetworkAPI.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Alamofire

enum NetworkAPI {
    case everyonesFavoriteCats(limit: Int)
    case catsByMood(mood: String, limit: Int)
    case tags
}

enum RequestTask {
    case plain
    case parameters(parameters: [String: Any], encoding: ParameterEncoding)
}

extension NetworkAPI {
    
    var baseURL: URL {
        URL(string: "https://cataas.com/api/")!
    }
    
    var path: String {
        switch self {
            case .everyonesFavoriteCats, .catsByMood:
                return "cats"
                
            case .tags:
                return "tags"
        }
    }
    
    var method: HTTPMethod {
        HTTPMethod.get
    }
    
    var request: RequestTask {
        switch self {
            case .everyonesFavoriteCats(let limit):
                return .parameters(
                    parameters: [
                        "tags": "cute",
                        "limit": limit
                    ],
                    encoding: URLEncoding.default
                )
                
            case .catsByMood(let mood, let limit):
                return .parameters(
                    parameters: [
                        "tags": mood,
                        "limit": limit
                    ],
                    encoding: URLEncoding.default
                )
                
            case .tags:
                return .plain
        }
    }
}
