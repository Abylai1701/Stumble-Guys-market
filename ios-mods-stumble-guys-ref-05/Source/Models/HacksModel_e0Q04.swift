import Foundation

struct HacksListModel: Codable {
    let hacks: Hacks
}

// MARK: - ModsClass
struct Hacks: Codable {
    let hacks: [HacksModel]

    enum CodingKeys: String, CodingKey {
        case hacks = "Hacks"
    }
}

struct HacksModel: Codable {
    var title: String
    var description: String
    var imagePath: String
    var isTop: Bool
    var isNew: Bool

    enum CodingKeys: String, CodingKey {
        case title = "id4to4b4"
        case description = "lpiv2rr8l"
        case imagePath = "36s"
        case isTop = "top"
        case isNew = "new"
    }
}
