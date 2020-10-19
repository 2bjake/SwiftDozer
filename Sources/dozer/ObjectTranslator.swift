//
//  ObjectTranslator.swift
//
//
//  Created by Jake Foster on 8/10/20.
//

import Foundation

struct HashableCodingKey<T>: Hashable {
    static func == (lhs: HashableCodingKey<T>, rhs: HashableCodingKey<T>) -> Bool {
        lhs.codingKey.stringValue == rhs.codingKey.stringValue
    }

    let codingKey: CodingKey

    init(_ codingKey: CodingKey) {
        self.codingKey = codingKey
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(T.self))
        hasher.combine(codingKey.stringValue)
    }

}

struct KeyMapping<FromType: Mappable, ToType: Mappable> {
    typealias FromKey = FromType.MappingKeys
    typealias ToKey = ToType.MappingKeys

    fileprivate var mapping: [(fromKey: FromKey, toKey: ToKey)]

    init(_ mapping: [(fromKey: FromKey, toKey: ToKey)] = []) {
        self.mapping = mapping
    }

    mutating func addMapping(from: FromKey, to: ToKey) {
        mapping.append((from, to))
    }
}

struct ObjectTranslator<FromType: FromMappable, ToType: ToMappable> {
    typealias FromKey = FromType.MappingKeys
    typealias ToKey = ToType.MappingKeys

    private typealias HashableFromKey = HashableCodingKey<FromType>

    private let keyMapping: [HashableFromKey : ToKey]
    init(keyMapping: KeyMapping<FromType, ToType>) {
        self.keyMapping = keyMapping.mapping.reduce(into: [:]) { result, element in
            result[HashableCodingKey<FromType>(element.fromKey)] = element.toKey
        }
    }

    func keyEncodingStrategy(_ fromKey: [CodingKey]) -> CodingKey {
        let fromKey = fromKey.last!
        if let decodeKey = self.keyMapping[HashableFromKey(fromKey)] {
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
