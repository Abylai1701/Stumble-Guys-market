//
//  TipsViewModel.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import Foundation
import DataCache

class CharactersViewModel {
    weak var delegate: ViewModelDelegate?
    
    private var configs = Configs_e0Q04.shared
    private var originalItems: [CharactersModel] = []
    private let dataDownloader = DropboxDownloader_e0Q04()
    private let tipsFavoritesKey = "CharactersFavoritesKey"
    
    var tipItem: CharactersModel?
    var items: [CharactersModel] = [] {
        didSet {
            delegate?.itemsDidUpdate_e0Q04()
        }
    }
    var currentSortingCategory: SortingCategory = .all {
        didSet {
            updateItemsBasedOnCategory()
        }
    }
    
    func filterItems(with query: String?) {
        guard let query = query, !query.isEmpty else {
            items = originalItems
            return
        }
        
        let lowercasedQuery = query.lowercased()
        items = originalItems.filter {
            $0.title.lowercased().contains(lowercasedQuery) ||
            $0.description.lowercased().contains(lowercasedQuery)
        }
    }
    
    func fetchTipsFromDropbox(completion: @escaping () -> Void) {
        // Проверяем наличие изменений в JSON перед загрузкой данных
        
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            
            if let cachedData = DataCache.instance.readData(forKey: self.configs.locationsCacheKey),
               let cachedMods = try? JSONDecoder().decode([CharactersModel].self, from: cachedData) {
                self.originalItems = cachedMods
                self.items = cachedMods
                self.delegate?.itemsDidUpdate_e0Q04()
                completion()
            }
            
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.fetchTipsFromDropbox(completion: completion)
                }
            }
            return
        }
        
//        checkForJsonChanges { [weak self] hasChanged in
//            guard let self = self else { return }
//            
//            if hasChanged || self.configs.charactersFileHasChanged {
//                // Если JSON изменился, очищаем кэш и загружаем данные
//                DataCacheManager_e0Q04.shared.clearCharactersCache()
//                self.downloadMods(completion: completion)
//            } else {
                // Попытка загрузить данные из кэша
                if let cachedData = DataCache.instance.readData(forKey: configs.charactersCacheKey),
                   let cachedTips = try? JSONDecoder().decode([CharactersModel].self, from: cachedData) {
                    self.originalItems = cachedTips
                    self.items = cachedTips
                    self.delegate?.itemsDidUpdate_e0Q04()  // Notify the ViewController
                    completion()
                } else {
                    // Если в кэше нет данных, загружаем снова
                    self.downloadMods(completion: completion)
                }
//            }
//        }
    }
    
    private func downloadMods(completion: @escaping () -> Void) {
        // Fetch data from Dropbox
        dataDownloader.fetchData_e0Q04(fromPath: DropboxAuthManagerConstants.charactersFilePath, decodingType: CharacterListModel.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let tipList):
                    self.configs.charactersFileHasChanged = false
                    var updatedTips = tipList.characters.characters
                    let dispatchGroup = DispatchGroup()
                    
                    for (index, tip) in updatedTips.enumerated() {
                        dispatchGroup.enter()
                        let imagePathWithDirectory = DropboxAuthManagerConstants.charactersDirectoryPath + tip.imagePath
                        self.dataDownloader.fetchImageLink_e0Q04(forPath: imagePathWithDirectory) { link in
                            if let link = link {
                                updatedTips[index].imagePath = link
                            } else {
                                print("Error fetching image link for \(tip.title)")
                            }
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        self.originalItems = updatedTips
                        self.items = updatedTips
                        
                        // Cache the fetched data
                        if let dataToCache = try? JSONEncoder().encode(updatedTips) {
                            DataCache.instance.write(data: dataToCache, forKey: self.configs.charactersCacheKey)
                        }
                        completion()
                    }
                    
                case .failure(let error):
                    print("Error fetching tips: \(error)")
                    completion()
                }
            }
        }
    }
    
    // Check json for changes
    func checkForJsonChanges(completion: @escaping (Bool) -> Void) {
        let tipsFilePath = DropboxAuthManagerConstants.charactersFilePath
        print("Checking for JSON changes at path: \(tipsFilePath)")
        
        dataDownloader.fetchRawData(fromPath: tipsFilePath) { [weak self] result in
            switch result {
            case .success(let data):
                let newDataHash = data.sha256()
                let storedHash = UserDefaults.standard.string(forKey: self?.configs.charactersCacheHashKey ?? "") ?? ""
                
                print("Fetched Data Hash: \(newDataHash)")
                print("Stored Hash: \(storedHash)")
                
                if newDataHash != storedHash {
                    print("JSON has changed. Updating stored hash and fetching new data.")
                    UserDefaults.standard.set(newDataHash, forKey: self?.configs.charactersCacheHashKey ?? "")
                    completion(true)
                } else {
                    print("No changes in JSON. Using cached data.")
                    completion(false)
                }
                
            case .failure(let error):
                print("Failed to fetch raw data: \(error)")
                completion(false)
            }
        }
    }
    
    func addTipToFavorites(_ tip: CharactersModel) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.title == tip.title }) else { return }
        favorites.append(tip)
        saveFavorites(favorites)
    }
    
    private func getFavorites() -> [CharactersModel] {
        guard let data = UserDefaults.standard.data(forKey: tipsFavoritesKey),
              let favorites = try? JSONDecoder().decode([CharactersModel].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: [CharactersModel]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: tipsFavoritesKey)
        }
    }
    
    func isTipFavorite(_ tip: CharactersModel) -> Bool {
        return getFavorites().contains { $0.title == tip.title }
    }
    
    func toggleModFavorite(_ tip: CharactersModel) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.title == tip.title }) {
            favorites.remove(at: index)
        } else {
            favorites.append(tip)
        }
        saveFavorites(favorites)
    }
    
    func updateItemsBasedOnCategory() {
        switch currentSortingCategory {
        case .all:
            items = originalItems
        case .favorites:
            items = getFavorites()
        case .new:
            items = originalItems.filter { $0.isNew == true }
        case .top:
            items = originalItems.filter { $0.isTop == true }
        }
    }
}
