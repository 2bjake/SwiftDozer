//
//  Mappable.swift
//  
//
//  Created by Jake Foster on 10/19/20.
//

import Foundation

protocol FromMappable: Encodable {
    associatedtype MappingKeys : CodingKey, Hashable
}

protocol ToMappable: Decodable {
    associatedtype MappingKeys : CodingKey
}

typealias Mappable = FromMappable & ToMappable
