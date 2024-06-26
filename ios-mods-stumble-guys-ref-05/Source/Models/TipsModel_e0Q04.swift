import Foundation

struct TipListModel: Codable {
    let guides: Tips
}

// MARK: - Mods
struct Tips: Codable {
    let skins: [TipsModel]

    enum CodingKeys: String, CodingKey {
        case skins = "Skins"
    }
}

struct TipsModel: Codable {
    var title: String
    var description: String
    var imagePath: String
    var isTop: Bool?
    var isNew: Bool?

    enum CodingKeys: String, CodingKey {
        case title = "yiyv497zrq"
        case description = "fdub"
        case imagePath = "83m"
        case isTop = "top"
        case isNew = "new"
    }
}
