//
//  Notification.swift
//  Academy-Life
//
//  Created by 서희재 on 11/22/24.
//

import Foundation

struct Notification: Codable, Identifiable {
    let id: Int
    let notiGroupCd: Int
    let courseID: Int
    let courseName: String
    let notiTitle: String
    let notiContents: String?
    let postID: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "notiID"
        case notiGroupCd
        case courseID
        case courseName
        case notiTitle
        case notiContents
        case postID
        case createdAt
    }
}

struct NotificationResult: Codable {
    let notification: [Notification]
}
