import Foundation

struct CharacterListModel: Codable {
    let characters: Characters
}

// MARK: - Mods
struct Characters: Codable {
    let characters: [CharactersModel]

    enum CodingKeys: String, CodingKey {
        case characters = "Characters"
    }
}

struct CharactersModel: Codable {
    var title: String
    var description: String
    var imagePath: String
    var isTop: Bool?
    var isNew: Bool?

    enum CodingKeys: String, CodingKey {
        case title = "kj1i"
        case description = "buwff_"
        case imagePath = "xv3qwocjn"
        case isTop = "top"
        case isNew = "new"
    }
}
