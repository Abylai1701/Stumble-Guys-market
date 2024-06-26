import Foundation
import DataCache

class HacksViewModel_e0Q04 {
    
    weak var delegate: ViewModelDelegate?
    
    private var configs = Configs_e0Q04.shared
    private var originalItems: [HacksModel] = []
    private let dataDownloader = DropboxDownloader_e0Q04()
    private let hacksFavoritesKey = "HacksFavoritesKey"
    var hackItem: HacksModel?
    var items: [HacksModel] = [] {
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
    
    func fetchHacksFromDropbox(completion: @escaping () -> Void) {
        
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            
            if let cachedData = DataCache.instance.readData(forKey: self.configs.hacksCacheKey),
               let cachedMods = try? JSONDecoder().decode([HacksModel].self, from: cachedData) {
                self.originalItems = cachedMods
                self.items = cachedMods
                self.delegate?.itemsDidUpdate_e0Q04()
                completion()
            }
            
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.fetchHacksFromDropbox(completion: completion)
                }
            }
            return
        }
        // Первоначальная проверка наличия изменений
//        checkForJsonChanges { hasChanged in
//            if hasChanged || self.configs.hacksFileHasChanged {
//                // Очистка кэша, если файл изменился
//                DataCacheManager_e0Q04.shared.clearHacksCache()
//                self.downloadHacks(completion: completion)
//            } else {
                // Попытка загрузить данные из кэша
                if let cachedData = DataCache.instance.readData(forKey: self.configs.hacksCacheKey),
                   let cachedHacks = try? JSONDecoder().decode([HacksModel].self, from: cachedData) {
                    self.originalItems = cachedHacks
                    self.items = cachedHacks
                    self.delegate?.itemsDidUpdate_e0Q04()
                    completion()
                } else {
                    // Если в кэше нет данных, загружаем снова
                    self.downloadHacks(completion: completion)
                }
//            }
//        }
    }

    private func downloadHacks(completion: @escaping () -> Void) {
        // Проверка доступности сети
        if !NetworkStatusMonitor_e0Q04.shared.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                ConnectionAlertHelperWithReturn_e0Q04.shared.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.downloadHacks(completion: completion)
                }
            }
            return
        }

        // Загрузка данных с Dropbox
        dataDownloader.fetchData_e0Q04(fromPath: DropboxAuthManagerConstants.hacksFilePath, decodingType: HacksListModel.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let hackList):
                    self.configs.hacksFileHasChanged = false
                    var updatedHacks = hackList.hacks.hacks
                    let dispatchGroup = DispatchGroup()
                    
                    for (index, hack) in updatedHacks.enumerated() {
                        dispatchGroup.enter()
                        let imagePathWithDirectory = DropboxAuthManagerConstants.hacksDirectoryPath + hack.imagePath
                        self.dataDownloader.fetchImageLink_e0Q04(forPath: imagePathWithDirectory) { link in
                            if let link = link {
                                updatedHacks[index].imagePath = link
                            } else {
                                print("Error fetching image link for \(hack.title)")
                            }
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        self.originalItems = updatedHacks
                        self.items = updatedHacks

                        // Кэширование данных
                        if let dataToCache = try? JSONEncoder().encode(updatedHacks) {
                            DataCache.instance.write(data: dataToCache, forKey: self.configs.hacksCacheKey)
                        }
                        completion()
                    }

                case .failure(let error):
                    print("Error fetching hacks: \(error)")
                }
            }
        }
    }

    func checkForJsonChanges(completion: @escaping (Bool) -> Void) {
        let hacksFilePath = DropboxAuthManagerConstants.hacksFilePath
        print("Checking for JSON changes at path: \(hacksFilePath)")

        dataDownloader.fetchRawData(fromPath: hacksFilePath) { [weak self] result in
            switch result {
            case .success(let data):
                let newDataHash = data.sha256()
                let storedHash = UserDefaults.standard.string(forKey: self?.configs.hacksCacheHashKey ?? "") ?? ""

                print("Fetched Data Hash: \(newDataHash)")
                print("Stored Hash: \(storedHash)")

                if newDataHash != storedHash {
                    print("JSON has changed. Updating stored hash and fetching new data.")
                    UserDefaults.standard.set(newDataHash, forKey: self?.configs.hacksCacheHashKey ?? "")
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

    
    func addHackToFavorites(_ hack: HacksModel) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.title == hack.title }) else { return }
        favorites.append(hack)
        saveFavorites(favorites)
    }
    
    private func getFavorites() -> [HacksModel] {
        guard let data = UserDefaults.standard.data(forKey: hacksFavoritesKey),
              let favorites = try? JSONDecoder().decode([HacksModel].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: [HacksModel]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: hacksFavoritesKey)
        }
    }
    
    func isHackFavorite(_ hack: HacksModel) -> Bool {
        return getFavorites().contains { $0.title == hack.title }
    }
    
    func toggleModFavorite(_ hack: HacksModel) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.title == hack.title }) {
            favorites.remove(at: index)
        } else {
            favorites.append(hack)
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
    
    init() {
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
    }
}
