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

extension Person: FromMappable {
    enum MappingKeys: CodingKey {
        case name
        case dob
        case city
        case state
    }
}

extension Record: ToMappable {
    enum MappingKeys: CodingKey {
        case fullName
        case dateOfBirth
        case city
        case zip
    }
}

func convert() throws {
    let p = Person(name: "Tim Johnson", dob: Date(), city: "Austin", state: "Texas")

    let t = ObjectTranslator<Person, Record>(keyMapping: [
        .name: .fullName,
        .dob: .dateOfBirth
    ])

    print(try t.translate(p)) // Record(fullName: "Tim Johnson", dateOfBirth: 2020-08-11 03:52:30 +0000)
}

try convert()
