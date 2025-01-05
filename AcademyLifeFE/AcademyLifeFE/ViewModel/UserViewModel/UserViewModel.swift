//
//  UserViewModel.swift
//  Academy-Life
//
//  Created by 서희재 on 12/4/24.
//

import SwiftUI
import Alamofire
import SVProgressHUD

class UserViewModel: ObservableObject {
    @Published var message = ""
    @Published var showEditProfileAlert = false
    @Published var showEditPasswordAlert = false
    @Published var showImageUploadAlert = false
    @Published var isEditSucceeded = false
    @Published var user = User()
    @Published var currentImage: UIImage? = nil
    @Published var images: [UIImage] = []
    @Published var afterSignup = false
    
    let host = AppConfig.baseURL
    var headers: HTTPHeaders = []
    
    func getUserInfo(userIDGiven: Int?) {
        // 회원 정보 조회 화면에 들어오면 회원 정보 수정 상태값 초기화
        isEditSucceeded = false
        
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let endPoint = "\(host)/user/\(userID)"
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        if token != nil {
            headers = [
                "token": "Bearer \(token!)",
                "Cache-Control": "no-cache",
                "If-None-Match": "",
                "If-Modified-Since": ""
            ]
        }
        
        AF.request(endPoint, method: .get, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200 ..< 300:
                    self.isEditSucceeded = true
                    do {
                        if let data = response.data {
                            let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                            self.user = userResult.user
                            print(self.user)
                            if let profileImage = self.user.profileImage {
                                self.fetchImage(from: profileImage)
                            }
                        }
                    } catch let error {
                        self.showEditProfileAlert = true
                        self.message = authErrorHandler(mode: .errorDecodingFailure)
                        print(error)
                    }
                case 300 ..< 600:
                    self.showEditProfileAlert = true
                    self.isEditSucceeded = false
                    do {
                        if let data = response.data {
                            let error = try JSONDecoder().decode(APIError.self, from: data)
                            self.message = error.message
                        }
                    } catch let error {
                        self.message = authErrorHandler(mode: .errorDecodingFailure)
                        print(error)
                    }
                default:
                    self.showEditProfileAlert = true
                    self.isEditSucceeded = false
                    self.message = authErrorHandler(mode: .errorUnknown)
                }
            }
        }
    }
    
    func editProfile(userName: String, nickname: String, mobile: String) {
        isEditSucceeded = false
        SVProgressHUD.show()
        
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let endPoint = "\(host)/user/\(userID)"
        
        let params: Parameters = [
            "userName": userName,
            "nickname": nickname,
            "mobile": mobile
        ]
        
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let headers: HTTPHeaders = [
            "token": "Bearer \(token)",
            "Cache-Control": "no-cache",
            "If-None-Match": "",
            "If-Modified-Since": ""
        ]
        
        AF.request(endPoint, method: .patch, parameters: params, headers: headers).response { response in
            if let statusCode = response.response?.statusCode {
                SVProgressHUD.dismiss()
                self.showEditProfileAlert = true
                switch statusCode {
                case 200 ..< 300: // API에서 정상적으로 처리 됐을 때
                    if let _ = response.data {
                        self.message = "회원정보가 정상적으로 수정됐어요."
                        self.isEditSucceeded = true
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
                default: // 위의 에러가 아닌 다른 문제가 발생했을 때
                    self.message = "알 수 없는 에러가 발생했어요."
                }
            }
        }
    }
    
    func editPassword(password: String, confirmPassword: String) {
        isEditSucceeded = false
        
        // 비밀번호가 일치하는지 검증하기
        if password != "" && password == confirmPassword {
            SVProgressHUD.show()
            
            let userID = UserDefaults.standard.integer(forKey: "userID")
            let endPoint = "\(host)/user/password/\(userID)"
            
            let params: Parameters = [
                "password": password,
            ]
            
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            
            let headers: HTTPHeaders = [
                "token": "Bearer \(token)",
                "Cache-Control": "no-cache",
                "If-None-Match": "",
                "If-Modified-Since": ""
            ]
            
            AF.request(endPoint, method: .patch, parameters: params, headers: headers).response { response in
                if let statusCode = response.response?.statusCode {
                    SVProgressHUD.dismiss()
                    self.showEditPasswordAlert = true
                    switch statusCode {
                    case 200 ..< 300: // API에서 정상적으로 처리 됐을 때
                        self.isEditSucceeded = true
                        if let _ = response.data {
                            self.message = "비밀번호가 정상적으로 수정됐어요."
                        }
                    case 300 ..< 600: // API에서 에러가 났을 떄
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                            } catch let error {
                                self.message = authErrorHandler(mode: .errorDecodingFailure)
                                print(error)
                            }
                        }
                    default: // 위의 에러가 아닌 다른 문제가 발생했을 때
                        self.message = authErrorHandler(mode: .errorUnknown)
                    }
                }
            }
        } else {
            self.showEditPasswordAlert = true
            self.message = "비밀번호가 비어있거나 일치하지 않아요.\n다시 한 번 확인해주세요."
        }
    }
    
    // 이미지 가져오기: 이미지 이름으로 UIImage를 생성하고 UI를 업데이트하기
    func fetchImage(from imageName: String) {
        let imagePath = "https://\(AppConfig.blobContainerDomain)/academylife/\(imageName)"
        
        AF.request(imagePath).responseData { response in
            switch response.result {
            case .success(let image):
                if let downloadedImage = UIImage(data: image) {
                    DispatchQueue.main.async {
                        self.currentImage = downloadedImage
                        self.images = [self.currentImage!]
                    }
                } else {
                    print("이미지 가져오기 실패: SA가 반환하지 않음")
                }
            case .failure(let error):
                print("이미지 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadProfileImage(image: UIImage, userIDGiven: Int?) {
        var userID: Int = 0
        SVProgressHUD.show()
        
        if userIDGiven != nil {
            userID = userIDGiven ?? 0
        } else {
            userID = UserDefaults.standard.integer(forKey: "userID")
        }
        
        let endPoint = "\(host)/user/profileImage/\(userID)"
        
        let token = UserDefaults.standard.string(forKey: "token")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token ?? "")",
            "Content-Type": "multipart/form-data",
        ]
        
        let formData = MultipartFormData()
        
        // 이미지 형식에 따라 ContentType 변화시키기
        let imageType = getImageType(image: image)
        guard let imageData = (imageType == "image/jpeg") ? image.jpegData(compressionQuality: 0.5) : (imageType == "image/png") ? image.pngData() : nil
        else {
            message = "지원하지 않는 이미지 형식이에요."
            showImageUploadAlert = true
            return
        }
        
        formData.append(imageData, withName: "images", fileName: "image.\(imageType == "image/jpeg" ? "jpg" : "png")", mimeType: imageType)
        
        AF.upload(multipartFormData: formData, to: endPoint, method: .post, headers: headers)
            .responseDecodable(of: UserResult.self) { response in
                if let statusCode = response.response?.statusCode {
                    SVProgressHUD.dismiss()
                    self.showImageUploadAlert = true
                    switch statusCode {
                    case 200 ..< 300: // API에서 정상적으로 처리 됐을 때
                        if let data = response.data {
                            do {
                                let profileImageUploadResult = try JSONDecoder().decode(ProfileImageUploadResult.self, from: data)
                                if let profileImage = profileImageUploadResult.profileImage {
                                    self.fetchImage(from: profileImage)
                                }
                                self.message = "이미지가 정상적으로 등록됐어요."
                            } catch {
                                self.message = authErrorHandler(mode: .errorDecodingFailure)
                                print(error)
                            }
                        }
                    case 300 ..< 600: // API에서 에러가 났을 떄
                        if let data = response.data {
                            do {
                                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                                self.message = apiError.message
                            } catch let error {
                                self.message = authErrorHandler(mode: .errorDecodingFailure)
                                print(error)
                            }
                        }
                    default: // 위의 에러가 아닌 다른 문제가 발생했을 때
                        self.message = authErrorHandler(mode: .errorUnknown)
                    }
                }
            }
    }
    
    func getImageType(image: UIImage) -> String {
        if image.jpegData(compressionQuality: 0.5) != nil {
            return "image/jpeg"
        }
        
        if image.pngData() != nil {
            return "image/png"
        }
        
        return "unknown"
    }
}
