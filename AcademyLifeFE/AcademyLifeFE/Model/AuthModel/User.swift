//
//  User.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import Foundation

struct User: Codable {
    var userID: Int
    var email: String
    var authCd: String
    var userName: String
    var nickname: String
    var mobile: String
    var kakao: String?
    var apple: String?
    var profileImage: String?
    
    init(userID: Int = 0, email: String = "", authCd: String = "", userName: String = "", nickname: String = "", mobile: String = "", kakao: String? = nil, apple: String? = nil, profileImage: String? = nil) {
            self.userID = userID
            self.email = email
            self.authCd = authCd
            self.userName = userName
            self.nickname = nickname
            self.mobile = mobile
            self.kakao = kakao
            self.apple = apple
            self.profileImage = profileImage
        }
}

struct LoginResult: Codable {
    let token: String
    let user: User
}

struct UserResult: Codable {
    let user: User
}

struct SocialAuthResult: Codable {
    let token: String?
    let user: User?
    let loginMethod: String
    let socialID: String
}

struct ProfileImageUploadResult: Codable {
    let profileImage: String?
}

enum LoginMethod: String {
    case kakao = "kakao"
    case apple = "apple"
    case timi = "timi"
    
    static func message(for loginMethod: LoginMethod) -> String {
        return loginMethod.rawValue
    }
}

enum AuthErrorMessages: String {
    case errorUnknown = "알 수 없는 에러가 발생했어요.\n잠시 후에 다시 시도해주세요."
    case errorDecodingFailure = "데이터를 불러오지 못했어요."
    case errorExistingEmail = "이미 사용된 이메일이에요.\n다른 이메일을 입력해주세요."
    case errorInvalidEmail = "이메일 형식이 일치하지 않아요.\n다시 한 번 확인해주세요."
    case errorInvalidPassword = "비밀번호가 비어있거나 일치하지 않아요.\n다시 한 번 확인해주세요."
}
