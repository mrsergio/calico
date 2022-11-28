//
//  NetworkProtocol.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Alamofire
import Combine

protocol NetworkProtocol {
    func fetchByTag(_ tag: String, limit: Int) async throws -> [CatModel]
    func fetchAvailableTags() async throws -> [String]
}
