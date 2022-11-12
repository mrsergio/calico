//
//  Reusable.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation

protocol Reusable: AnyObject { }

extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
}
