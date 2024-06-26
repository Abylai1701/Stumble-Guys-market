//
//  FileDateChecker.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 06.12.2023.
//

import Foundation

class FileDateChecker_e0Q04 {
    static let shared = FileDateChecker_e0Q04()
    
    private var dataDownloader = DropboxDownloader_e0Q04()
    
    func checkForFileDateChanges(filePath: String, userDefaultsDateKey: String, userDefaultsFlagKey: String) {
//        print("🌐 Checking for file changes at path: \(filePath)")

        dataDownloader.fetchFileModificationDate(fromPath: filePath) { result in
            switch result {
            case .success(let lastModified):
                let storedDate = UserDefaults.standard.object(forKey: userDefaultsDateKey) as? Date ?? Date.distantPast
//                print("🗓 Fetched Modification Date: \(lastModified)")
//                print("🔒 Stored Date: \(storedDate)")

                let fileChanged = lastModified > storedDate
                if fileChanged {
                    print("‼️ File has changed. Updating stored date.")
                    UserDefaults.standard.set(lastModified, forKey: userDefaultsDateKey)
                    UserDefaults.standard.set(true, forKey: userDefaultsFlagKey)
                    // Note: Not setting the userDefaultsFlagKey to true here
                } else {
//                    print("✅ No changes in file.")
                    // Optionally, set the flag to false if the file hasn't changed
//                    UserDefaults.standard.set(false, forKey: userDefaultsFlagKey)
                }

            case .failure(let error):
                print("🛑 Failed to fetch file modification date: \(error)")
//                UserDefaults.standard.set(false, forKey: userDefaultsFlagKey)
            }
        }
    }

    
    private init() {
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
    }
}
