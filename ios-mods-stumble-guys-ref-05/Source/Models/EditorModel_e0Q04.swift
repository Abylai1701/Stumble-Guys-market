import Foundation

struct EditorModel: Codable {
    var editor: Editor
    
    enum CodingKeys: String, CodingKey {
        case editor = "1LrU10u3EVeQoPrE"
    }
}

struct Editor: Codable {
    var boy, girl: [Category]
    
    enum CodingKeys: String, CodingKey {
        case boy = "Boy_3d70Ys7kwyS6oPrE"
        case girl = "Girl_3d70Ys7kwyS6oPrE"
    }
}

struct Category: Codable {
    var title: String
    var defaultItem: String?
    var isResetEnabled: Bool
    var zIndex: String
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case title = "title_43oj9dv6v4LgoPrE"
        case defaultItem = "defaultItem_43oj9dv6v4LgoPrE"
        case isResetEnabled = "isResetEnabled_43oj9dv6v4LgoPrE"
        case zIndex = "zIndex_43oj9dv6v4LgoPrE"
        case items = "items_43oj9dv6v4LgoPrE"
    }
}

struct Item: Codable {
    var id, path, preview: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_V9910RSg4fj9oPrE"
        case path = "path_V9910RSg4fj9oPrE"
        case preview = "preview_V9910RSg4fj9oPrE"
    }
}
