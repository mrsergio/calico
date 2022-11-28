//
//  NetworkProtocol.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import Combine

public protocol NetworkProtocol {
    func fetchByTag<T: Decodable>(_: T.Type, tag: String, limit: Int) async throws -> T
    func fetchAvailableTags() async throws -> [String]
}
