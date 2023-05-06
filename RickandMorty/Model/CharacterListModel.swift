import Foundation

struct CharacterListModel: Codable {
    let info: InfoModel?
    let results: [CharacterModel]?
    let error: String?
    
    struct InfoModel: Codable {
        let count: Int
        let pages: Int
        let next: String?
    }
}
