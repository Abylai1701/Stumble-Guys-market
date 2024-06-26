import Foundation

struct ModListModel: Codable {
    let mods: Mods
}

// MARK: - Mods
struct Mods: Codable {
    let mods: [ModModel]

    enum CodingKeys: String, CodingKey {
        case mods = "Mods"
    }
}

// MARK: - Mod
struct ModModel: Codable {
    var title: String
    var description: String
    var image: String
    var modPath: String
    var isTop: Bool
    var isNew: Bool

    enum CodingKeys: String, CodingKey {
        case title = "izb"
        case description = "dvgqzn"
        case image = "rozvu0cb2"
        case modPath = "uzur"
        case isTop = "top"
        case isNew = "new"
    }
}





