//
//  SocialAuthViewModel.swift
//  Academy-Life
//
//  Created by 서희재 on 11/26/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD

class SocialAuthViewModel: ObservableObject {
    @Published var loginMethod: LoginMethod? = nil
    @Published var APILoginMethod: String = ""
    @Published var socialID: String = ""
    @Published var user = User()
    @Published var userID: Int = 0
    @Published var showSocialLoginAlert = false
    @Published var showSocialSignupAlert = false
    @Published var message: String = ""
    @Published var socialSignupSucceeded = false
    
    let host = AppConfig.baseURL
    @AppStorage("deviceToken") var deviceToken: String?
    
    func socialSignUp(email: String, userName: String, nickname: String, mobile: String, loginMethod: String, socialID: String) {
        SVProgressHUD.show()
        
        let endPoint = "\(host)/user/signup/social"
        
        let params: Parameters = [
            "email": email,
            "userName": userName,
            "nickname": nickname,
            "mobile": mobile,
            "loginMethod": loginMethod,
            "socialID": socialID
        ]
        
        let headers: HTTPHeaders = [
            "Cache-Control": "no-cache",
            "If-None-Match": "",
            "If-Modified-Since": ""
        ]
        
        AF.request(endPoint, method: .post, parameters: params, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                SVProgressHUD.dismiss()
                self.socialSignupSucceeded = false
                self.showSocialSignupAlert = true
                switch statusCode {
                case 200 ..< 300: // API에서 정상적으로 처리 됐을 때
                    if let data = response.data {
                        do {
                            let newSocialUser = try JSONDecoder().decode(UserResult.self, from: data)
                            self.user = newSocialUser.user
                            self.userID = newSocialUser.user.userID
                            self.message = "회원가입을 완료했어요."
                            self.socialSignupSucceeded = true
                        } catch let error {
                            self.message = authErrorHandler(mode: .errorDecodingFailure)
                            print(error.localizedDescription)
                        }
                    }
                case 400:
                    self.socialSignupSucceeded = false
                    if let _ = response.data {
                        self.message = authErrorHandler(mode: .errorInvalidEmail)
                    }
                case 409:
                    self.socialSignupSucceeded = false
                    if let _ = response.data {
                        self.message = authErrorHandler(mode: .errorExistingEmail)
                    }
                case 300 ..< 600: // API에서 에러가 났을 떄
                    if let data = response.data {
                        do {
                            let apiError = try JSONDecoder().decode(APIError.self, from: data)
                            self.message = apiError.message
                        } catch let error {
                            self.message = error.localizedDescription
                        }
                    }
                default:
                    self.message = authErrorHandler(mode: .errorUnknown)
                }
            }
        }
    }
    
    func socialLogin(loginMethod: LoginMethod, socialID: String) {
        var isLoggedIn = false
        let endPoint = "\(host)/user/login/social"
        
        let stringLoginMethod = LoginMethod.message(for: loginMethod)
        
        var params: Parameters = [
            "loginMethod": stringLoginMethod,
            "socialID": socialID
        ]
        
        if deviceToken != nil {
            params["deviceToken"] = deviceToken
        }
        
        AF.request(endPoint, method: .post, parameters: params).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200 ..< 300:
                    if let data = response.data {
                        do {
                            let socialAuthResult = try JSONDecoder().decode(SocialAuthResult.self, from: data)
                            // API가 회원 정보를 반환하면 로그인 처리하기
                            if let existingUser = socialAuthResult.user {
                                self.user = existingUser
                                isLoggedIn = true
                                UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
                                UserDefaults.standard.set(self.user.userID, forKey: "userID")
                                UserDefaults.standard.set(self.user.authCd, forKey: "authCd")
                                UserDefaults.standard.set(socialAuthResult.loginMethod, forKey: "loginMethod")
                                if let token = socialAuthResult.token {
                                    UserDefaults.standard.set("Bearer \(token)", forKey: "token")
                                }
                            } else {
                                // API가 회원 정보가 아닌 nil을 반환하면 회원가입 창으로 이동시키기
                                self.APILoginMethod = socialAuthResult.loginMethod
                                self.socialID = socialAuthResult.socialID
                                self.showSocialLoginAlert = true
                                self.message = "해당 정보로 가입된 회원이 없어요.\n회원가입 화면으로 이동할게요."
                            }
                        } catch let error {
                            self.showSocialLoginAlert = true
                            self.message = error.localizedDescription
                        }
                    }
                case 300 ..< 600:
                    if let data = response.data {
                        self.showSocialLoginAlert = true
                        do {
                            let error = try JSONDecoder().decode(APIError.self, from: data)
                            self.message = error.message
                        } catch let error {
                            self.message = error.localizedDescription
                        }
                    }
                default:
                    self.message = authErrorHandler(mode: .errorUnknown)
                }
            }
        }
    }
}
