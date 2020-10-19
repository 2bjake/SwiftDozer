//
//  ObjectTranslator.swift
//
//
//  Created by Jake Foster on 8/10/20.
//

import Foundation

struct ObjectTranslator<FromType: FromMappable, ToType: ToMappable> {
    typealias FromKey = FromType.MappingKeys
    typealias ToKey = ToType.MappingKeys

    private let keyMapping: [String : ToKey]
    init(keyMapping: [FromType.MappingKeys: ToType.MappingKeys] = [:]) {
        self.keyMapping = keyMapping.reduce(into: [:]) { result, element in
            result[element.key.stringValue] = element.value
        }
    }

    func keyEncodingStrategy(_ fromKeys: [CodingKey]) -> CodingKey {
        let fromKey = fromKeys.last!
        if let decodeKey = self.keyMapping[fromKey.stringValue] {
            return decodeKey
        } else {
            return fromKey
        }
    }

    func translate(_ from: FromType) throws -> ToType {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .custom(keyEncodingStrategy)
        let data = try encoder.encode(from)
        return try JSONDecoder().decode(ToType.self, from: data)
    }
}
