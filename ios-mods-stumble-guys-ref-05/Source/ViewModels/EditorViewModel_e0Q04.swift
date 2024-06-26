//
//  EditorViewModel.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 27.11.2023.
//

import Foundation
import DataCache
import SDWebImage
import PDFKit

enum CharacterType: String {
    case boy
    case girl
}

class EditorViewModel_e0Q04 {
    
    private var activeDownloadTasks: [URLSessionDataTask] = []
    var dataLoaded = false
    var showLoaderOneTime = true
    private let maxRetryAttempts = 3
    private let batchSize = 20
    private let timeoutInterval: TimeInterval = 120
    
    private var undoStack: [([String: String], String)] = []
    private var redoStack: [([String: String], String)] = []
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    
    var selectedCategory = "Gender"

    var totalImageCount = 0.0
    var originalImageCount = 0.0
    var onePercentOfOriginal = 0.0
    var completionPercentage = 0.0
    var onPercentageUpdate: ((Double) -> Void)?
    
    // Character data
    var characterType: CharacterType = .girl
    var predefinedItemIds: [String: String] = [:]
    var characterUUID: UUID?
    var characterPhoto = ""
    
    // Default character items
    var defaultItems: [String: String] = ["0": "1", "1": "1", "2": "1", "3": "1", "4": "1", "5": "1", "6": "0"]
    
    // Initial values
    var initialItems: [String: String] = [:]
    var initialCharacterGender: CharacterType?

    var characterList: [Character] = []
    var boyCategories: [Category] = []
    var girlCategories: [Category] = []
    var currentItems: [Item] = []
    let downloader = DropboxDownloader_e0Q04()
    var selectedItemIndex: IndexPath?
    var isSexSelectionActive: Bool = false
    private var coreDataManager = CoreDataManager_e0Q04.shared
    
    var selectedCharacterIndexPath: IndexPath?
    
    private var numberOfPreloadedImages = 0
    private let networkingMonitor = NetworkStatusMonitor_e0Q04.shared
    
    func clearCharacterData_e0Q04() {
        characterUUID = nil
        characterPhoto = ""
        predefinedItemIds = [:]
        initialItems = [:]
    }
    func showUndoItems() {
        print(undoStack.count)
    }
    func resetItems_e0Q04() {
        predefinedItemIds = initialItems
    }
    func resetGender_e0Q04() {
        characterType = initialCharacterGender ?? .boy
    }
    func saveInitialGender_e0Q04() {
        initialCharacterGender = characterType
    }
    func saveInitialItems_e0Q04() {
        initialItems = predefinedItemIds
    }
    func setDefaultItems_e0Q04() {
        predefinedItemIds = defaultItems
        characterType = initialCharacterGender ?? .boy
    }
    func setDefaultItems() {
        predefinedItemIds = defaultItems
    }
    func fetchCharactersFromCoreData_e0Q04() {
        self.characterList = coreDataManager.fetchAllCharacters()
    }
    func sortCharacterList_e0Q04() {
        characterList.sort(by: { $0.lastUpdatedDate ?? Date() > $1.lastUpdatedDate ?? Date() })
    }
    func currentCategory(selectedButtonTitle: String?) -> Category? {
        let categories = characterType == .boy ? boyCategories : girlCategories
        return categories.first(where: { $0.title == selectedButtonTitle })
    }
    func fetchData_e0Q04(completion: ((EditorModel) -> Void)? = nil) {
        print("fetchData called in EditorViewModel")
        
        if !networkingMonitor.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            ConnectionAlertHelperWithReturn_e0Q04.shared.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.fetchData_e0Q04(completion: completion)
            }
            return
        }
        downloader.fetchData_e0Q04(fromPath: DropboxAuthManagerConstants.editorFilePath, decodingType: EditorModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let editorData):
                    self?.boyCategories = editorData.editor.boy
                    self?.girlCategories = editorData.editor.girl
                    completion?(editorData)
                case .failure(let error):
                    print("Failed to fetch editor data from Dropbox. Error: \(error.localizedDescription)")
                    SceneDelegate.shared?.window?.topViewController?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    func preloadAllImages(completion: @escaping () -> Void) {
        
        networkCheck()
        
        let allItems = (boyCategories + girlCategories).flatMap { $0.items }
        let imagePaths = allItems.flatMap { [$0.path, $0.preview] }
        
        totalImageCount = Double(imagePaths.count)
        originalImageCount = totalImageCount
        onePercentOfOriginal = Double(totalImageCount) * 0.01
        
        preloadImagesBatch(imagePaths: imagePaths, startIndex: 0, completion: completion)
    }

    private func preloadImagesBatch(imagePaths: [String], startIndex: Int, completion: @escaping () -> Void) {
        let endIndex = min(startIndex + batchSize, imagePaths.count)
        let batch = Array(imagePaths[startIndex..<endIndex])

        let dispatchGroup = DispatchGroup()

        for imagePath in batch {
            dispatchGroup.enter()
            preloadImage(for: imagePath, attempt: 0) {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            if endIndex < imagePaths.count {
                self.preloadImagesBatch(imagePaths: imagePaths, startIndex: endIndex, completion: completion)
            } else {
                completion()
            }
        }
    }

    func preloadImage(for imagePath: String, attempt: Int = 0, completion: @escaping () -> Void) {
        
        networkCheck()
        
        print("Preloading image for path: \(imagePath)")

        if DataCache.instance.readData(forKey: imagePath) != nil {
            print("Image already cached for path \(imagePath)")
            completion()
            return
        }

        downloader.fetchImageLink_e0Q04(forPath: imagePath) { link in
            DispatchQueue.main.async {
                guard let link = link, let url = URL(string: link) else {
                    print("No link returned or invalid URL for path: \(imagePath)")
                    completion()
                    return
                }

                SDWebImageDownloader.shared.config.downloadTimeout = self.timeoutInterval

                if imagePath.hasSuffix(".pdf") {
                    self.downloadAndConvertPDF(from: url, forPath: imagePath, completion: completion)
                } else {
                    SDWebImageDownloader.shared.downloadImage(with: url) { image, _, error, _ in
                        if let image = image, let data = image.pngData() {
                            DataCache.instance.write(data: data, forKey: imagePath)
                            
                            print("Image preloaded and cached successfully for path \(imagePath)")
                            self.decrementPercents()
                            print("Total image count is \(self.totalImageCount)")
                            completion()
                        } else if let error = error as NSError?, error.code == NSURLErrorTimedOut && attempt < self.maxRetryAttempts {
                            print("Timeout error occurred, retrying... Attempt \(attempt + 1)")
                            self.preloadImage(for: imagePath, attempt: attempt + 1, completion: completion)
                        } else {
                            print("Error preloading image for path \(imagePath): \(error?.localizedDescription ?? "Unknown error")")
                            completion()
                            SceneDelegate.shared?.window?.topViewController?.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }

    private func downloadAndConvertPDF(from url: URL, forPath imagePath: String, completion: @escaping () -> Void) {
        let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let pdfDocument = PDFDocument(data: data), let page = pdfDocument.page(at: 0) {
                let pdfPageRect = page.bounds(for: .mediaBox)
                
                let targetHeight: CGFloat = 300
                let aspectRatio = pdfPageRect.width / pdfPageRect.height
                let scaledWidth = targetHeight * aspectRatio
                let scaledSize = CGSize(width: scaledWidth, height: targetHeight)
                
                let renderer = UIGraphicsImageRenderer(size: scaledSize)
                let image = renderer.image { ctx in
                    ctx.cgContext.saveGState()
                    ctx.cgContext.translateBy(x: 0.0, y: scaledSize.height)
                    ctx.cgContext.scaleBy(x: scaledSize.width / pdfPageRect.width, y: -scaledSize.height / pdfPageRect.height)
                    page.draw(with: .mediaBox, to: ctx.cgContext)
                    ctx.cgContext.restoreGState()
                }

                if let pngData = image.pngData() {
                    DataCache.instance.write(data: pngData, forKey: imagePath)
                    print("Converted PDF to PNG and cached for path \(imagePath)")
                    self.decrementPercents()
                    print("Total image count is \(self.totalImageCount)")
                }

                completion()
            } else if let error = error {
                print("Error downloading PDF for conversion: \(error.localizedDescription)")
                completion()
            }
        }
        downloadTask.resume()
    }
    
    private func decrementPercents() {
        if totalImageCount <= onePercentOfOriginal {
            totalImageCount = 0
        } else {
            totalImageCount -= onePercentOfOriginal
        }

        let progressPercentage = Double(totalImageCount) / Double(originalImageCount) * 100.0

        completionPercentage = 100.0 - progressPercentage

        print("⏳ Progress is: \(progressPercentage)%")
        print("✅ Completion is: \(completionPercentage)%")
        print("1% is: \(onePercentOfOriginal)%")

        let newPercentage = 100.0 - Double(totalImageCount) / Double(originalImageCount) * 100.0
        onPercentageUpdate?(newPercentage)
    }
    
    func networkCheck() {
        if !networkingMonitor.isNetworkAvailable {
            print("No internet connection, aborting download task.")
            ConnectionAlertHelperWithReturn_e0Q04.shared.show()
            return
        }
    }
    
    func addToHistory() {
        let currentState = (predefinedItemIds, selectedCategory)

        if let lastState = undoStack.last, lastState.1 != selectedCategory {
            undoStack.append((predefinedItemIds, lastState.1))
        }

        undoStack.append(currentState)
        redoStack.removeAll()
    }
    func printStack() {
        print("\(undoStack.count)")
    }
    func undo() {
        guard !undoStack.isEmpty else { return }
        let prevState = undoStack.removeLast()
        redoStack.append((predefinedItemIds, selectedCategory))
        predefinedItemIds = prevState.0
        selectedCategory = prevState.1
    }

    func redo() {
        guard !redoStack.isEmpty else { return }
        let nextState = redoStack.removeLast()
        undoStack.append((predefinedItemIds, selectedCategory))
        predefinedItemIds = nextState.0
        selectedCategory = nextState.1
    }

    func resetHistory() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
}
