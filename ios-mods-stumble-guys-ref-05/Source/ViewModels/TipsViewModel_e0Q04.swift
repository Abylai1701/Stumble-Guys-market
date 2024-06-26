//
//  TipsViewModel.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 22.11.2023.
//

import Foundation
import DataCache

class TipsViewModel_e0Q04 {
    weak var delegate: ViewModelDelegate?
    
    private var configs = Configs_e0Q04.shared
    private var originalItems: [TipsModel] = []
    private let dataDownloader = DropboxDownloader_e0Q04()
    private let tipsFavoritesKey = "TipsFavoritesKey"
    
    var tipItem: TipsModel?
    var items: [TipsModel] = [] {
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
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            if let cachedData = DataCache.instance.readData(forKey: self.configs.tipsCacheKey),
               let cachedMods = try? JSONDecoder().decode([TipsModel].self, from: cachedData) {
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
        // Проверяем наличие изменений в JSON
//        checkForJsonChanges { hasChanged in
//            if hasChanged || self.configs.tipsFileChanged {
//                DataCacheManager_e0Q04.shared.clearTipsCache()
//                self.downloadTips(completion: completion)
//            } else {
                // Иначе пытаемся загрузить данные из кэша
                if let cachedData = DataCache.instance.readData(forKey: self.configs.tipsCacheKey),
                   let cachedTips = try? JSONDecoder().decode([TipsModel].self, from: cachedData) {
                    self.originalItems = cachedTips
                    self.items = cachedTips
                    self.delegate?.itemsDidUpdate_e0Q04()
                    completion()
                } else {
                    // Если данные в кэше не найдены, загружаем снова
                    self.downloadTips(completion: completion)
                }
//            }
//        }
    }

    private func downloadTips(completion: @escaping () -> Void) {
        // Проверка доступности сети
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.downloadTips(completion: completion)
                }
            }
            return
        }

        // Загрузка данных с Dropbox
        dataDownloader.fetchData_e0Q04(fromPath: DropboxAuthManagerConstants.tipsFilePath, decodingType: TipListModel.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let tipList):
                    self.configs.tipsFileChanged = false
                    var updatedTips = tipList.guides.skins
                    let dispatchGroup = DispatchGroup()
                    
                    for (index, tip) in updatedTips.enumerated() {
                        dispatchGroup.enter()
                        let imagePathWithDirectory = DropboxAuthManagerConstants.tipsDirectoryPath + tip.imagePath
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

                        // Кэширование данных
                        if let dataToCache = try? JSONEncoder().encode(updatedTips) {
                            DataCache.instance.write(data: dataToCache, forKey: self.configs.tipsCacheKey)
                        }
                        completion()
                    }

                case .failure(let error):
                    print("Error fetching tips: \(error)")
                }
            }
        }
    }

    func checkForJsonChanges(completion: @escaping (Bool) -> Void) {
        let tipsFilePath = DropboxAuthManagerConstants.tipsFilePath
        print("Checking for JSON changes at path: \(tipsFilePath)")

        dataDownloader.fetchRawData(fromPath: tipsFilePath) { [weak self] result in
            switch result {
            case .success(let data):
                let newDataHash = data.sha256()
                let storedHash = UserDefaults.standard.string(forKey: self?.configs.tipsCacheHashKey ?? "") ?? ""

                print("Fetched Data Hash: \(newDataHash)")
                print("Stored Hash: \(storedHash)")

                if newDataHash != storedHash {
                    print("JSON has changed. Updating stored hash and fetching new data.")
                    UserDefaults.standard.set(newDataHash, forKey: self?.configs.tipsCacheHashKey ?? "")
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

    
    func addTipToFavorites(_ tip: TipsModel) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.title == tip.title }) else { return }
        favorites.append(tip)
        saveFavorites(favorites)
    }
    
    private func getFavorites() -> [TipsModel] {
        guard let data = UserDefaults.standard.data(forKey: tipsFavoritesKey),
              let favorites = try? JSONDecoder().decode([TipsModel].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: [TipsModel]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: tipsFavoritesKey)
        }
    }
    
    func isTipFavorite(_ tip: TipsModel) -> Bool {
        return getFavorites().contains { $0.title == tip.title }
    }
    
    func toggleModFavorite(_ tip: TipsModel) {
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
