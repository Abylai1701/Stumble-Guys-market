//
//  DataCacheManager.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 05.12.2023.
//

import Foundation
import DataCache

class DataCacheManager_e0Q04 {
    static let shared = DataCacheManager_e0Q04()
    private let configs = Configs_e0Q04.shared
        
    func clearAllCache() {
        DataCache.instance.cleanAll()
    }
    
    func clearModsCache() {
        DataCache.instance.clean(byKey: configs.modsCacheKey)
        DataCache.instance.clean(byKey: configs.modsCacheHashKey)
    }
    
    func clearHacksCache() {
        DataCache.instance.clean(byKey: configs.hacksCacheKey)
        DataCache.instance.clean(byKey: configs.hacksCacheHashKey)
    }
    
    func clearTipsCache() {
        DataCache.instance.clean(byKey: configs.tipsCacheKey)
        DataCache.instance.clean(byKey: configs.tipsCacheHashKey)
    }
    
    func clearLocationsCache() {
        DataCache.instance.clean(byKey: configs.locationsCacheKey)
        DataCache.instance.clean(byKey: configs.locationsCacheHashKey)
    }
    
    func clearCharactersCache() {
        DataCache.instance.clean(byKey: configs.charactersCacheKey)
        DataCache.instance.clean(byKey: configs.charactersCacheHashKey)
    }
}
