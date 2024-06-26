import Foundation
import DeviceKit

class Configs_e0Q04 {
    static let shared = Configs_e0Q04()
    
    public var isAppFirstLaunch = true
    
//    // Cache Data
    let modsCacheKey = "modsCacheKey"
    let modsCacheHashKey = "modsCacheHashKey"
    let hacksCacheKey = "hacksCacheKey"
    let hacksCacheHashKey = "hacksCacheHashKey"
    let tipsCacheKey = "tipsCacheKey"
    let tipsCacheHashKey = "tipsCacheHashKey"
    let charactersCacheKey = "charactersCacheKey"
    let charactersCacheHashKey = "charactersCacheHashKey"
    let locationsCacheKey = "locationsCacheKey"
    let locationsCacheHashKey = "locationsCacheHashKey"
        
    var modsLastModifiedDate: Date? {
        get { UserDefaults.standard.object(forKey: "modsLastModifiedDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "modsLastModifiedDate") }
    }
    
    var hacksLastModifiedDate: Date? {
        get { UserDefaults.standard.object(forKey: "hacksLastModifiedDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "hacksLastModifiedDate") }
    }
    
    var editorLastModifiedDate: Date? {
        get { UserDefaults.standard.object(forKey: "editorLastModifiedDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "editorLastModifiedDate") }
    }
    
    var tipsLastModifiedDate: Date? {
        get { UserDefaults.standard.object(forKey: "skinsLastModifiedDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "skinsLastModifiedDate") }
    }
    
    var charactersLastModifiedDate: Date? {
        get { UserDefaults.standard.object(forKey: "charactersLastModifiedDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "charactersLastModifiedDate") }
    }
    
    var locationsLastModifiedDate: Date? {
        get { UserDefaults.standard.object(forKey: "locationsLastModifiedDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "locationsLastModifiedDate") }
    }
    
    var modsFileHasChanged: Bool {
        get { UserDefaults.standard.bool(forKey: "modsFileHasChanged") }
        set { UserDefaults.standard.set(newValue, forKey: "modsFileHasChanged") }
    }
    
    var hacksFileHasChanged: Bool {
        get { UserDefaults.standard.bool(forKey: "hacksFileHasChanged") }
        set { UserDefaults.standard.set(newValue, forKey: "hacksFileHasChanged") }
    }
    
    var editorFileChanged: Bool {
        get { UserDefaults.standard.bool(forKey: "editorFileChanged") }
        set { UserDefaults.standard.set(newValue, forKey: "editorFileChanged") }
    }
    
    var tipsFileChanged: Bool {
        get { UserDefaults.standard.bool(forKey: "tipsFileChanged") }
        set { UserDefaults.standard.set(newValue, forKey: "tipsFileChanged") }
    }
    
    var charactersFileHasChanged: Bool {
        get { UserDefaults.standard.bool(forKey: "charactersFileHasChanged") }
        set { UserDefaults.standard.set(newValue, forKey: "charactersFileHasChanged") }
    }
    
    var locationsFileHasChanged: Bool {
        get { UserDefaults.standard.bool(forKey: "locationsFileHasChanged") }
        set { UserDefaults.standard.set(newValue, forKey: "locationsFileHasChanged") }
    }
    public var currentDevice = Device.current
    public var sizeOfConfView: CGFloat = Device.current.isPad ? 250:172
    public var sizeOfConfView2: CGFloat = Device.current.isPad ? 250:201
    public var sizeOfConfView3: CGFloat = Device.current.isPad ? 300:210

}
