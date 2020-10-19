import Foundation

struct Person {
    let name: String
    let dob: Date
    let city: String
    let state: String
}

struct Record {
    let fullName: String
    let dateOfBirth: Date
    let city: String
    let zip: String?
}

extension Person: Codable, Mappable {
    enum MappingKeys: CodingKey {
        case name
        case dob
        case city
        case state
    }
}

extension Record: Codable, Mappable {
    enum MappingKeys: CodingKey {
        case fullName
        case dateOfBirth
        case city
        case zip
    }
}

func convert() throws {
    let p = Person(name: "Tim Johnson", dob: Date(), city: "Austin", state: "Texas")

    // I want to make the mapping a regular map... but... that means the fromkey has to be hashable...
    var keyMapping = KeyMapping<Person, Record>()
    keyMapping.addMapping(from: .name, to: .fullName)
    keyMapping.addMapping(from: .dob, to: .dateOfBirth)

    let r = try ObjectTranslator(keyMapping: keyMapping).translate(p)
    print(r) // Record(fullName: "Tim Johnson", dateOfBirth: 2020-08-11 03:52:30 +0000)
}

try convert()
