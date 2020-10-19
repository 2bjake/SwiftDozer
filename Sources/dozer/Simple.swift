//
//  Simple.swift
//  
//
//  Created by Jake Foster on 10/19/20.
//

import Foundation

//struct SimpleObjectTranslator<From: Encodable, To: Decodable> {
//    private let encoder = JSONEncoder()
//    private let decoder = JSONDecoder()
//
//    init(_: To.Type) {}
//
//    func translate(_ from: From) throws -> To {
//        let data = try encoder.encode(from)
//        return try decoder.decode(To.self, from: data)
//    }
//}


//struct SimplePerson: Codable {
//    let name: String
//    let dob: Date
//    let dependencies: Int
//}
//
//struct SimpleRecord: Codable {
//    let name: String
//    let dob: Date
//    let dependencies: Int
//}
//
//func simpleConvert() throws {
//    let p = SimplePerson(name: "Tim Johnson", dob: Date(), dependencies: 5)
//    let r = try SimpleObjectTranslator(SimpleRecord.self).translate(p)
//    print(r)
//}
