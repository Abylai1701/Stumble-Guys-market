import Foundation
import DataCache

class ModsViewModel_e0Q04 {

    weak var delegate: ViewModelDelegate?
    
    private var configs = Configs_e0Q04.shared
    private var originalItems: [ModModel] = []
    private let dataDownloader = DropboxDownloader_e0Q04()
    private let modsFavoritesKey = "ModsFavoritesKey"
    var modItem: ModModel?
    var items: [ModModel] = [] {
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
            $0.title.lowercased().contains(lowercasedQuery)
        }
    }
    
    func fetchModsFromDropbox(completion: @escaping () -> Void) {
        // Проверяем наличие изменений в JSON перед загрузкой данных
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            
            if let cachedData = DataCache.instance.readData(forKey: self.configs.modsCacheKey),
               let cachedMods = try? JSONDecoder().decode([ModModel].self, from: cachedData) {
                self.originalItems = cachedMods
                self.items = cachedMods
                self.delegate?.itemsDidUpdate_e0Q04()
                completion()
            }
            
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.fetchModsFromDropbox(completion: completion)
                }
            }
            return
        }
//        checkForJsonChanges { [weak self] hasChanged in
//            guard let self = self else { return }  // Проверяем, что self не nil

//            if hasChanged || self.configs.modsFileHasChanged {
//                // Если JSON изменился, очищаем кэш и загружаем данные
//                DataCacheManager_e0Q04.shared.clearModsCache()
//                self.downloadMods(completion: completion)
//            } else {
                // Попытка загрузить данные из кэша
                if let cachedData = DataCache.instance.readData(forKey: self.configs.modsCacheKey),
                   let cachedMods = try? JSONDecoder().decode([ModModel].self, from: cachedData) {
                    self.originalItems = cachedMods
                    self.items = cachedMods
                    self.delegate?.itemsDidUpdate_e0Q04()
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
        dataDownloader.fetchData_e0Q04(fromPath: DropboxAuthManagerConstants.modsFilePath, decodingType: ModListModel.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let modList):
                    self.configs.modsFileHasChanged = false
                    var updatedMods = modList.mods.mods
                    let dispatchGroup = DispatchGroup()
                    
                    for (index, mod) in updatedMods.enumerated() {
                        dispatchGroup.enter()
                        let imagePathWithDirectory = DropboxAuthManagerConstants.modsDirectoryPath + mod.image
                        self.dataDownloader.fetchImageLink_e0Q04(forPath: imagePathWithDirectory) { link in
                            if let link = link {
                                updatedMods[index].image = link
                            } else {
                                print("Error fetching image link for \(mod.title)")
                            }
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        self.originalItems = updatedMods
                        self.items = updatedMods

                        // Cache the fetched data
                        if let dataToCache = try? JSONEncoder().encode(updatedMods) {
                            DataCache.instance.write(data: dataToCache, forKey: self.configs.modsCacheKey)
                        }
                        completion()
                    }

                case .failure(let error):
                    print("Error fetching mods: \(error)")
                }
            }
        }
    }

    
    func checkForJsonChanges(completion: @escaping (Bool) -> Void) {
        let modsFilePath = DropboxAuthManagerConstants.modsFilePath
        print("Checking for JSON changes at path: \(modsFilePath)")

        dataDownloader.fetchRawData(fromPath: modsFilePath) { [weak self] result in
            switch result {
            case .success(let data):
                let newDataHash = data.sha256()
                let storedHash = UserDefaults.standard.string(forKey: self?.configs.modsCacheHashKey ?? "") ?? ""

                print("Fetched Data Hash: \(newDataHash)")
                print("Stored Hash: \(storedHash)")

                if newDataHash != storedHash {
                    print("JSON has changed. Updating stored hash and fetching new data.")
                    UserDefaults.standard.set(newDataHash, forKey: self?.configs.modsCacheHashKey ?? "")
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
    
    func addModToFavorites(_ mod: ModModel) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.title == mod.title }) else { return }
        favorites.append(mod)
        saveFavorites(favorites)
    }
    
    private func getFavorites() -> [ModModel] {
        guard let data = UserDefaults.standard.data(forKey: modsFavoritesKey),
              let favorites = try? JSONDecoder().decode([ModModel].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: [ModModel]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: modsFavoritesKey)
        }
    }
    
    func isModFavorite(_ mod: ModModel) -> Bool {
        return getFavorites().contains { $0.title == mod.title }
    }
    
    func toggleModFavorite(_ mod: ModModel) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.title == mod.title }) {
            favorites.remove(at: index)
        } else {
            favorites.append(mod)
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
