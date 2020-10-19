//
//  Mappable.swift
//  
//
//  Created by Jake Foster on 10/19/20.
//

import Foundation

protocol Mappable {
    associatedtype MappingKeys : CodingKey
}

typealias FromMappable = Encodable & Mappable // need to also add requirement that mapping keys are hashable
typealias ToMappable = Decodable & Mappable


