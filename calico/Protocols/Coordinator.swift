//
//  Coordinator.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation

protocol Coordinator: AnyObject {
    var key: Coordinators { get }
    
    func start()
}

enum Coordinators {
    case app, main, detail
}
