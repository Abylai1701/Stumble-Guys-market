
//
//  DropboxAuthManager.swift
//

import Foundation
import SwiftyDropbox

struct DropboxAuthManagerConstants {
    static let appkey = "gc3sup0t8h2ecyv"
    static let appSecret = "a3gt4a9vsksmrfg"
    static let authCode = "czHFetFkAxAAAAAAAAAGDiaVUrfvaMOAmZtqNhPjlvA"
    static let refreshToken = "abnXTnDpfIwAAAAAAAAAAT_X2hN8RTU800zmd-mVYK53azArkvE9T1KtFGf-9BlH"

//    static let appkey = "hkxboriz9kzouj6"
//    static let appSecret = "rs0xellli0vijnd"
//    static let authCode = "czHFetFkAxAAAAAAAAAEunSEF7knUiQw4qfo34t4-pY"
//    static let refreshToken = "VMd1ftbvQnUAAAAAAAAAAXVzpSibcUHrdRpj37VWgj85WJerOTOL76-BxsiFjDFQ"

    
    static let apiLink = "https://api.dropboxapi.com/oauth2/token"
    
    static let modsFilePath = "/mods/mods.json"
    static let modsDirectoryPath = "/mods/"

    static let hacksFilePath = "/hacks/hacks.json"
    static let hacksDirectoryPath = "/hacks/"

    static let tipsFilePath = "/skins/skins.json"
    static let tipsDirectoryPath = "/skins/"

    static let charactersFilePath = "/characters/characters.json"
    static let charactersDirectoryPath = "/characters/"

    static let locationsFilePath = "/locations/locations.json"
    static let locationsDirectoryPath = "/locations/"

    static let editorFilePath = "/editor/editor.json"
}

class SharedTemproraryAcessToken {
    static let shared = SharedTemproraryAcessToken()
    
    var accessToken = ""
    
    private init() {}
}

final class DropboxAuthManager_e0Q04: NSObject {

    static let shared = DropboxAuthManager_e0Q04()

    public var client : DropboxClient?
    
    private var isInitialized = false

    func initDropBox() {
        guard !isInitialized else { return }
        DropboxClientsManager.setupWithAppKey(DropboxAuthManagerConstants.appkey)
        
        getAccessToken(refreshToken: DropboxAuthManagerConstants.refreshToken) { [weak self] accessToken in
            if let accessToken = accessToken {
                self?.client = DropboxClient(accessToken: accessToken)
                SharedTemproraryAcessToken.shared.accessToken = accessToken
                self?.isInitialized = true
                print("Dropbox client successfully initialized.")
            } else {
                print("Error while initializing Dropbox client.")
            }
        }
        getReshreshToken(authCode: DropboxAuthManagerConstants.authCode) { refreshToken in
            if let refreshToken {
                print("refresh token ✅", refreshToken)
                 self.getAccessToken(refreshToken: refreshToken) { access_token in
                     if let access_token {
                         self.client = DropboxClient(accessToken: access_token)
                         print("good job first open token 🫡 \(access_token),\(String(describing: self.client))")
                     }
                 }
            } else {
                print("error while getting refresh token ⚠️")
            }
        }
    }

    private func getAccessToken(refreshToken : String,completion: @escaping (String?) -> ()) {
        
        let username = DropboxAuthManagerConstants.appkey
        let password = DropboxAuthManagerConstants.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
    
        let parameters : Data = "refresh_token=\(refreshToken)&grant_type=refresh_token".data(using: .utf8)!
        let url = URL(string: DropboxAuthManagerConstants.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters
    
        let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data Available")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                completion(responseJSON["access_token"] as? String)
            }else {
                print("error")
            }
        }
    
        task.resume()
    }
    
    private func getReshreshToken(authCode: String, completion: @escaping (String?) -> ()) {
    
        let username = DropboxAuthManagerConstants.appkey
        let password = DropboxAuthManagerConstants.appSecret
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
    
        let parameters : Data = "code=\(authCode)&grant_type=authorization_code".data(using: .utf8)!
        let url = URL(string: DropboxAuthManagerConstants.apiLink)!
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        apiRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        apiRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        apiRequest.httpBody = parameters
    
        let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data Available")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if let refreshToken = responseJSON["refresh_token"] as? String {
                    completion(refreshToken)
                } else {
                    // completion(DropBoxKeys.refreshToken)
                }
            } else {
                print("error")
            }
        }
    
        task.resume()
    }
}
