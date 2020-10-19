import Foundation

struct SimplePerson: Codable {
    let name: String
    let dob: Date
    let dependencies: Int
}

struct SimpleRecord: Codable {
    let name: String
    let dob: Date
    let dependencies: Int
}

func simpleConvert() throws {
    let p = SimplePerson(name: "Tim Johnson", dob: Date(), dependencies: 5)
    let r = try SimpleObjectTranslator(SimpleRecord.self).translate(p)
    print(r)
}

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

extension Person: Codable {
    enum CodingKeys: CodingKey {
        case name
        case dob
        case city
        case state
    }
}

extension Record: Codable {
    enum CodingKeys: CodingKey {
        case fullName
        case dateOfBirth
        case city
        case zip
    }
}

func convert() throws {
    let t = Record.CodingKeys.self
    let p = Person(name: "Tim Johnson", dob: Date(), city: "Austin", state: "Texas")

    var keyMapping = KeyMapping<Person.CodingKeys, Record.CodingKeys>()
    keyMapping.map(.name, to: .fullName)
    keyMapping.map(.dob, to: .dateOfBirth)

    let r = try ObjectTranslator(Record.self, with: keyMapping).translate(p)
    print(r) // Record(fullName: "Tim Johnson", dateOfBirth: 2020-08-11 03:52:30 +0000)
}

try simpleConvert()
try convert()
