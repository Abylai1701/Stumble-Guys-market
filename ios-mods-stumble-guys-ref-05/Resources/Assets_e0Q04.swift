//
//  Assets.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 20.11.2023.
//

import UIKit

enum Assets {

    enum Icon {
        static let back = UIImage(named: "iconBack")!
        static let lock2 = UIImage(named: "iconLock2")!
        static let back2 = UIImage(named: "iconBack2")!
        static let check = UIImage(named: "iconCheck")!
        static let download = UIImage(named: "iconDownload")!
        static let downloadGreen = UIImage(named: "iconDownload2")!
        static let favorite1 = UIImage(named: "iconFavorite1")!
        static let favorite2 = UIImage(named: "iconFavorite2")!
        static let favorite3 = UIImage(named: "iconFavorite3")!
        static let favorite4 = UIImage(named: "iconFavorite4")!
        static let menu = UIImage(named: "iconMenu")!
        static let pen = UIImage(named: "iconPen")!
        static let search = UIImage(named: "iconSearch")!
        static let star = UIImage(named: "iconStar")!
        static let trash = UIImage(named: "iconTrash")!
        static let undo = UIImage(named: "iconUndo")!
        static let lock = UIImage(named: "iconLock")!
        static let discard = UIImage(named: "iconDiscard")!
        static let iconBlackSearch = UIImage(named: "iconBlackSearch")!
        static let iconDiscard2 = UIImage(named: "iconDiscard2")!
        static let iconDiscard3 = UIImage(named: "iconDiscard3")!
        static let iconDiscard4 = UIImage(named: "iconDiscard4")!
        static let iconAddCharacter = UIImage(named: "iconAddCharacter")!
        static let iconBack3 = UIImage(named: "iconBack3")!
        static let iconBack4 = UIImage(named: "iconBack4")!
        static let iconNext = UIImage(named: "iconNext")!
        static let iconNext2 = UIImage(named: "iconNext2")!
    }
    
    enum Image {
        static let platform = UIImage(named: "imagePlatform")!
        static let discard = UIImage(named: "imageDiscard")!
        static let exampleImage = UIImage(named: "exampleCharacter")!
    }
    
    enum Montserrat {
        static func black(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Black", size: size)!
        }
        static func bold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Bold", size: size)!
        }
        static func extraBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-ExtraBold", size: size)!
        }
        static func extraLight(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-ExtraLight", size: size)!
        }
        static func light(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Light", size: size)!
        }
        static func medium(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Medium", size: size)!
        }
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Regular", size: size)!
        }
        static func semiBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-SemiBold", size: size)!
        }
        static func thin(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Montserrat-Thin", size: size)!
        }
    }

    enum Inter {
        static func black(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-Black", size: size)!
        }
        static func bold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-Bold", size: size)!
        }
        static func extraBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-ExtraBold", size: size)!
        }
        static func extraLight(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-ExtraLight", size: size)!
        }
        static func light(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-Light", size: size)!
        }
        static func medium(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-Medium", size: size)!
        }
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-Regular", size: size)!
        }
        static func semiBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-SemiBold", size: size)!
        }
        static func thin(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Inter-Thin", size: size)!
        }
    }

    enum LondrinaSolid {
        static func black(_ size: CGFloat) -> UIFont {
            return UIFont(name: "LondrinaSolid-Black", size: size)!
        }
        static func light(_ size: CGFloat) -> UIFont {
            return UIFont(name: "LondrinaSolid-Light", size: size)!
        }
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "LondrinaSolid-Regular", size: size)!
        }
        static func thin(_ size: CGFloat) -> UIFont {
            return UIFont(name: "LondrinaSolid-Thin", size: size)!
        }
    }
    enum Fredoka {
        static func bold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Fredoka-Bold", size: size)!
        }
        static func light(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Fredoka-Light", size: size)!
        }
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Fredoka-Regular", size: size)!
        }
        static func medium(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Fredoka-Medium", size: size)!
        }
        static func semiBold(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Fredoka-SemiBold", size: size)!
        }
    }
    enum Background {
        static let clouds = UIImage(named: "cloudsBG")!
        static let gradient = UIImage(named: "gradientBG")!
    }
}

struct Color {
    static let black = "colorBlack"
    static let white = "colorWhite"
    static let blue = "colorBlue"
    static let darkBlue = "colorDarkBlue"
    static let lightBlue = "colorLightBlue"
    static let red = "colorRed"
    static let green = "colorGreen"
    static let gray = "colorGray"
    static let pink = "colorPink"
}

struct Cell {
    static let card = "CardCellIdentifier"
    static let modsCard = "ModsCardCellIdentifier"
    static let empty = "EmptyCellIdentifier"
    static let discardButton = "DiscardButtonIdentifier"
    static let item = "ItemCellIdentifier"
    static let character = "CharacterCellIdentifier"
    static let addNew = "AddNewCellIdentifier"
    static let gender = "GenderCellIdentifier"
    static let search = "SearchCellIdentifier"
    static let hacks = "HacksCellIdentifier"
    static let characters = "CharactersCellIdentifier"
    static let skins = "SkinsCellIdentifier"
}

struct Animation {
    static let dots = "4tJShP8hjv"
}
