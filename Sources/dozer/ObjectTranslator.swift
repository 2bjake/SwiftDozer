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

struct SimpleObjectTranslator<From: Encodable, To: Decodable> {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(_: To.Type) {}

    func translate(_ from: From) throws -> To {
        let data = try encoder.encode(from)
        return try decoder.decode(To.self, from: data)
    }
}

struct KeyMapping<FromKey: CodingKey, ToKey: CodingKey> {
    fileprivate var mapping: [(fromKey: FromKey, toKey: ToKey)]

    init(_ mapping: [(fromKey: FromKey, toKey: ToKey)] = []) {
        self.mapping = mapping
    }

    mutating func map(_ from: FromKey, to: ToKey) {
        mapping.append((from, to))
    }
}

struct ObjectTranslator<From: Encodable, FromKey: CodingKey, To: Decodable, ToKey: CodingKey> {
    private typealias HashableFromKey = HashableCodingKey<From>

    private let keyMapping: [HashableFromKey : ToKey]
    init(_: To.Type, with mapping: KeyMapping<FromKey, ToKey>) {
        keyMapping = mapping.mapping.reduce(into: [:]) { result, element in
            result[HashableCodingKey<From>(element.fromKey)] = element.toKey
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

    func translate(_ from: From) throws -> To {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .custom(keyEncodingStrategy)
        let data = try encoder.encode(from)
        return try JSONDecoder().decode(To.self, from: data)
    }
}
