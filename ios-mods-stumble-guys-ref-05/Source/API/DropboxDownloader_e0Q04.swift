import UIKit
import Photos
import SwiftyDropbox

enum DataFetchError: Error {
    case networkError
    case dataDecodingError
    case imageFetchError
    case unknownError
}

class DropboxDownloader_e0Q04 {
    private var client: DropboxClient? {
        return DropboxAuthManager_e0Q04.shared.client
    }
    
    func fetchData_e0Q04<T: Codable>(fromPath path: String, decodingType: T.Type, completion: @escaping (Result<T, DataFetchError>) -> Void) {
        client?.files.download(path: path).response { [weak self] response, error in
            guard let self = self else {
                completion(.failure(.unknownError))
                return
            }

            if let error = error {
                self.logError("Error downloading data: \(error)")
                completion(.failure(.networkError))
                return
            }

            guard let data = response?.1 else {
                completion(.failure(.dataDecodingError))
                return
            }

            self.decodeData(data, type: decodingType, completion: completion)
        }
    }

    private func decodeData<T: Codable>(_ data: Data, type: T.Type, completion: (Result<T, DataFetchError>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(type, from: data)
            completion(.success(decodedData))
        } catch {
            logError("Error decoding data: \(error.localizedDescription)")
            completion(.failure(.dataDecodingError))
        }
    }

    private func logError(_ message: String) {
        // Replace print statements with more robust logging if necessary
        print(message)
    }
    
    func fetchImageLink_e0Q04(forPath path: String, completion: @escaping (String?) -> Void) {
        let correctedPath = path.hasPrefix("/") ? path : "/\(path)"
        
        client?.files.getTemporaryLink(path: correctedPath).response { response, error in
            if let link = response?.link {
                completion(link)
            } else {
                print("Unknown error occurred while fetching image link.")
                completion(nil)
            }
        }
    }
    
    func downloadModFile_e0Q04(modPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let correctedModPath = modPath.hasPrefix("/mods/") ? modPath : "/mods/\(modPath)"

        client?.files.getTemporaryLink(path: correctedModPath).response { response, error in
            guard let link = response?.link, let fileURL = URL(string: link) else {
                completion(.failure(NSError(domain: "DropboxDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not get temporary link for the file."])))
                return
            }

            let downloadTask = URLSession.shared.downloadTask(with: fileURL) { tempLocalUrl, response, error in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    do {
                        let fileName = (correctedModPath as NSString).lastPathComponent
                        let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let savedURL = documentsURL.appendingPathComponent(fileName)
                        
                        if FileManager.default.fileExists(atPath: savedURL.path) {
                            try FileManager.default.removeItem(at: savedURL)
                        }
                        
                        try FileManager.default.moveItem(at: tempLocalUrl, to: savedURL)
                        
                        completion(.success(savedURL))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "DropboxDataManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Download failed."])))
                }
            }
            
            downloadTask.resume()
        }
    }
    func downloadLocationFile_e0Q04(modPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let correctedModPath = modPath.hasPrefix("/locations/") ? modPath : "/locations/\(modPath)"

        client?.files.getTemporaryLink(path: correctedModPath).response { response, error in
            guard let link = response?.link, let fileURL = URL(string: link) else {
                completion(.failure(NSError(domain: "DropboxDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not get temporary link for the file."])))
                return
            }

            let downloadTask = URLSession.shared.downloadTask(with: fileURL) { tempLocalUrl, response, error in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    do {
                        let fileName = (correctedModPath as NSString).lastPathComponent
                        let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        let savedURL = documentsURL.appendingPathComponent(fileName)
                        
                        if FileManager.default.fileExists(atPath: savedURL.path) {
                            try FileManager.default.removeItem(at: savedURL)
                        }
                        
                        try FileManager.default.moveItem(at: tempLocalUrl, to: savedURL)
                        
                        completion(.success(savedURL))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error ?? NSError(domain: "DropboxDataManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Download failed."])))
                }
            }
            
            downloadTask.resume()
        }
    }
    func downloadImageAndSaveToPhotoAlbum(imagePath: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: imagePath) else {
            completion(.failure(NSError(domain: "DropboxDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image URL."])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "DropboxDataManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Could not decode image."])))
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if success {
                    completion(.success(()))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "DropboxDataManager", code: -3, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred while saving image to Photos."])))
                }
            }
        }.resume()
    }
    
    // Function to check json raw data for changes
    func fetchRawData(fromPath path: String, completion: @escaping (Result<Data, DataFetchError>) -> Void) {
        client?.files.download(path: path).response { response, error in
            if let error = error {
                print("Error downloading raw data: \(error)")
                completion(.failure(.networkError))
                return
            }

            guard let data = response?.1 else {
                completion(.failure(.dataDecodingError))
                return
            }

            completion(.success(data))
        }
    }
    
    // Function to check file meta date
    func fetchFileModificationDate(fromPath path: String, completion: @escaping (Result<Date, DataFetchError>) -> Void) {
        client?.files.getMetadata(path: path).response { response, error in
            if let error = error {
                print("Error fetching file metadata: \(error)")
                completion(.failure(.networkError))
                return
            }

            guard let fileMetadata = response as? Files.FileMetadata else {
                completion(.failure(.unknownError))
                return
            }

            let lastModified = fileMetadata.serverModified
            completion(.success(lastModified))
        }
    }
}
