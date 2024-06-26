import Foundation

struct locationsListModel: Codable {
    let maps: Maps
}

// MARK: - Mods
struct Maps: Codable {
    let maps: [LocationModel]

    enum CodingKeys: String, CodingKey {
        case maps = "Maps"
    }
}

// MARK: - Mod
struct LocationModel: Codable {
    var title: String
    var description: String
    var image: String
    var modPath: String
    var isTop: Bool
    var isNew: Bool

    enum CodingKeys: String, CodingKey {
        case title = "b6554"
        case description = "ldr3qz"
        case image = "06_5u"
        case modPath = "jni2"
        case isTop = "top"
        case isNew = "new"
    }
}





