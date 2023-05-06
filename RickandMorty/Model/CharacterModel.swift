import Foundation

struct CharacterModel: Codable {
    var uniqueID: UUID?
    let id: Int?
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: OriginModel
    let location: OriginModel
    let image: String
    let episode: [String]
    
    struct OriginModel: Codable {
        let name: String
        let url: String
    }
}
