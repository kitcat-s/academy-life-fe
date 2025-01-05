//
//  NotificationViewModel.swift
//  Academy-Life
//
//  Created by 서희재 on 11/22/24.
//

import SwiftUI
import Alamofire

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var showAlert = false
    @Published var isRead = false
    @Published var message = ""
    
    func fetchNotifications(userID: Int) {
        let host = AppConfig.baseURL
        @AppStorage("token") var token = ""
        
        let endPoint = "\(host)/notification/\(userID)"
        
        let headers: HTTPHeaders = [
            "token": "Bearer \(token)"
        ]
        
        AF.request(endPoint, method: .get, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200 ..< 300:
                    if let data = response.data {
                        do {
                            let notificationResult = try JSONDecoder().decode(NotificationResult.self, from: data)
                            self.notifications = notificationResult.notification
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                case 300 ..< 600:
                    if let data = response.data {
                        do {
                            let error = try JSONDecoder().decode(APIError.self, from: data)
                            print(error)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                default:
                    print("알 수 없는 에러 발생")
                }
            }
        }
    }
    
    func readNotification(notiID: Int) {
        let host = AppConfig.baseURL
        @AppStorage("token") var token = ""
        
        let endPoint = "\(host)/notification/\(notiID)"
        
        let headers: HTTPHeaders = [
            "token": "Bearer \(token)"
        ]
        
        AF.request(endPoint, method: .patch, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200 ..< 300:
                    if response.data != nil {
                        print("\(notiID)번 알림 읽음 처리 완료")
                    }
                case 300 ..< 600:
                    self.showAlert = true
                    if let data = response.data {
                        do {
                            let error = try JSONDecoder().decode(APIError.self, from: data)
                            self.message = error.message
                        } catch let error {
                            self.message = error.localizedDescription
                        }
                    }
                default:
                    print("알 수 없는 에러 발생")
                }
            }
        }
    }
}
