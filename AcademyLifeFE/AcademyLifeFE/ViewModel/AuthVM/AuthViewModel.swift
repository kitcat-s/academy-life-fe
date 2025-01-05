//
//  AuthViewModel.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD

class AuthViewModel: ObservableObject {
    @Published var message = ""
    @Published var showLoginAlert = false
    @Published var showSignUpAlert = false
    @Published var showEditProfileAlert = false
    @Published var user = User()
    @Published var signupSucceeded = false
    
    let host = AppConfig.baseURL
    var userID = UserDefaults.standard.integer(forKey: "userID")
    @AppStorage("deviceToken") var deviceToken: String?
    
    func login(email: String, password: String) {
        SVProgressHUD.show()
        
        var isLoggedIn = false
        let endPoint = "\(host)/user/login"
        
        var params: Parameters = [
            "email": email,
            "password": password,
        ]
        
        if deviceToken != nil {
            params["deviceToken"] = deviceToken
        }
        
        AF.request(endPoint, method: .post, parameters: params).response { response in
            if let statusCode = response.response?.statusCode {
                SVProgressHUD.dismiss()
                switch statusCode {
                case 200 ..< 300: // API에서 정상적으로 처리 됐을 때
                    if let data = response.data {
                        do {
                            let loginResult = try JSONDecoder().decode(LoginResult.self, from: data)
                            isLoggedIn = true
                            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
                            UserDefaults.standard.set(loginResult.user.userID, forKey: "userID")
                            UserDefaults.standard.set(loginResult.user.authCd, forKey: "authCd")
                            UserDefaults.standard.set("timiLogin", forKey: "loginMethod") // 자체 로그인일 경우 UserDefaults에 저장
                            UserDefaults.standard.set("Bearer \(loginResult.token)", forKey: "token")
                        } catch let error {
                            self.showLoginAlert = true
                            self.message = error.localizedDescription
                        }
                    }
                case 300 ..< 600: // API에서 에러가 났을 떄
                    self.showLoginAlert = true
                    if let data = response.data {
                        do {
                            let apiError = try JSONDecoder().decode(APIError.self, from: data)
                            self.message = apiError.message
                        } catch let error {
                            self.message = error.localizedDescription
                        }
                    }
                default: // 위의 에러가 아닌 다른 문제가 발생했을 때
                    self.message = authErrorHandler(mode: .errorUnknown)
                }
            }
        }
    }
    
    func signup(email: String, password: String, confirmPassword: String, userName: String, nickname: String, mobile: String, isTeacher: Bool) {
        // 비밀번호가 일치하는지 검증하기
        if password != "" && password == confirmPassword {
            
            SVProgressHUD.show()
            
            var endPoint = "\(host)/user/signup"
            
            if isTeacher {
                endPoint = "\(host)/user/signup/teacher"
            }
            
            var params: Parameters = [
                "email": email,
                "password": password,
                "userName": userName,
                "nickname": nickname,
                "mobile": mobile,
            ]
            
            if isTeacher {
                userID = UserDefaults.standard.integer(forKey: "userID")
                params["registerRef"] = userID
            }
            
            let headers: HTTPHeaders = [
                "Cache-Control": "no-cache",
                "If-None-Match": "",
                "If-Modified-Since": ""
            ]
            
            AF.request(endPoint, method: .post, parameters: params, headers: headers).response { response in
                if let statusCode = response.response?.statusCode {
                    SVProgressHUD.dismiss()
                    self.showSignUpAlert = true
                    switch statusCode {
                    case 200 ..< 300: // API에서 정상적으로 처리 됐을 때
                        if let data = response.data {
                            do {
                                let newUser = try JSONDecoder().decode(UserResult.self, from: data)
                                self.signupSucceeded = true
                                self.message = "회원가입을 완료했어요."
                                self.userID = newUser.user.userID
                            } catch let error {
                                self.message = authErrorHandler(mode: .errorDecodingFailure)
                                print(error.localizedDescription)
                            }
                        }
                    case 400:
                        self.signupSucceeded = false
                        if let _ = response.data {
                            self.message = authErrorHandler(mode: .errorInvalidEmail)
                        }
                    case 409:
                        self.signupSucceeded = false
                        if let _ = response.data {
                            self.message = authErrorHandler(mode: .errorExistingEmail)
                        }
                    case 300 ..< 600: // API에서 에러가 났을 떄
                        if let data = response.data {
                            self.signupSucceeded = false
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                            } catch let error {
                                self.message = error.localizedDescription
                            }
                        }
                    default: // 위의 에러가 아닌 다른 문제가 발생했을 때
                        self.signupSucceeded = false
                        self.message = authErrorHandler(mode: .errorUnknown)
                    }
                }
            }
        } else {
            self.showSignUpAlert = true
            self.message = authErrorHandler(mode: .errorInvalidPassword)
        }
    }
}
