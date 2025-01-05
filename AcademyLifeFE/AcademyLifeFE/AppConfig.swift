//
//  AppConfig.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import Foundation

struct AppConfig {
    static let baseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "HOST") as? String else {
            print("Info.plist에 HOST 값이 없어요.")
            fatalError("Info.plist에 HOST 값이 없어요.")
        }
        
        var resultUrl: String = ""
        if url.contains("localhost") {
            resultUrl = "http://\(url)"
        } else {
            resultUrl = "https://\(url)"
        }
        print("AppConfig baseURL > ", resultUrl)
        return resultUrl
    }()

    static let blobContainerDomain: String = {
        guard let domain = Bundle.main.object(forInfoDictionaryKey: "BLOB_CONTAINER_DOMAIN") as? String else {
            print("Info.plist에 BLOB_CONTAINER_DOMAIN 값이 없어요.")
            fatalError("Info.plist에 BLOB_CONTAINER_DOMAIN 값이 없어요.")
        }
        return domain
    }()
    
    static let apiKeyKakao: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String else {
            print("Info.plist에 KAKAO_API_KEY 값이 없어요.")
            fatalError("Info.plist에 KAKAO_API_KEY 값이 없어요.")
        }
        return apiKey
    }()
    
    static let azureOpenAIDomain: String = {
        guard let domain = Bundle.main.object(forInfoDictionaryKey: "AOAI_DOMAIN") as? String else {
            print("Info.plist에 AOAI_DOMAIN 값이 없어요.")
            fatalError("Info.plist에 AOAI_DOMAIN 값이 없어요.")
        }
        return domain
    }()
    
    static let apiKeyAzureOpenAI: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "AOAI_API_KEY") as? String else {
            print("Info.plist에 AOAI_API_KEY 값이 없어요.")
            fatalError("Info.plist에 AOAI_API_KEY 값이 없어요.")
        }
        return apiKey
    }()
    
    static let azureSTTDomain: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "STT_DOMAIN") as? String else {
            print("Info.plist에 STT_DOMAIN 값이 없어요.")
            fatalError("Info.plist에 STT_DOMAIN 값이 없어요.")
        }
        return apiKey
    }()
    static let azureTTSDomain: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "TTS_DOMAIN") as? String else {
            print("Info.plist에 TTS_DOMAIN 값이 없어요.")
            fatalError("Info.plist에 TTS_DOMAIN 값이 없어요.")
        }
        return apiKey
    }()
    static let apiKeyAzureSpeechService: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "SPEECH_API_KEY") as? String else {
            print("Info.plist에 SPEECH_API_KEY 값이 없어요.")
            fatalError("Info.plist에 SPEECH_API_KEY 값이 없어요.")
        }
        return apiKey
    }()
}
