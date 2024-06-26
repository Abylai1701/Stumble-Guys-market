//
//  LocalFileHelper.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 23.11.2023.
//

import UIKit

class LocalFileHelper_e0Q04 {
    static let shared = LocalFileHelper_e0Q04()

    func localFileURL(for modPath: String) -> URL? {
        let fileName = (modPath as NSString).lastPathComponent
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }

    func initiateDownload(for modPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        DropboxDownloader_e0Q04().downloadModFile_e0Q04(modPath: modPath, completion: completion)
    }
    func initiateDownloads(for modPath: String, completion: @escaping (Result<URL, Error>) -> Void) {
        DropboxDownloader_e0Q04().downloadLocationFile_e0Q04(modPath: modPath, completion: completion)
    }
}
