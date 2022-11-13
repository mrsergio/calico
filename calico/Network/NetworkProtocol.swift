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
    func fetchEveryonesFavorites(limit: Int) -> AnyPublisher<[CatModel], AFError>
    func fetchByMood(_ mood: String, limit: Int) -> AnyPublisher<[CatModel], AFError>
    func fetchAvailableTags() -> AnyPublisher<[String], AFError>
}
