//
//  SocialSignUpView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI

struct SocialSignUpView: View {
    @EnvironmentObject var socialAuthVM: SocialAuthViewModel
    @State var email: String = ""
    @State var userName: String = ""
    @State var nickname: String = ""
    @State var mobile: String = ""
    @Binding var navigateToSocialSignUp: Bool
    @State var navigateToUploadProfileImageView = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                PageHeading(title: "소셜 회원가입")
                
                ScrollView{
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "이메일을 입력해주세요", label: "이메일", text: $email)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                        CustomTextField(placeholder: "이름을 입력해주세요", label: "이름", text: $userName)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        CustomTextField(placeholder: "닉네임을 입력해주세요", label: "닉네임", text: $nickname)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        CustomTextField(placeholder: "전화번호를 입력해주세요", label: "전화번호", text: $mobile)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.decimalPad)
                    }.padding(.bottom, 28)
                    VStack(spacing: 16) {
                        WideButton(title: "회원가입", bgColor: .accentDefault) {
                            if email.isEmpty || userName.isEmpty || nickname.isEmpty || mobile.isEmpty {
                                socialAuthVM.message = "모든 항목을 입력해주세요."
                                socialAuthVM.showSocialSignupAlert = true
                            } else if mobile.count < 10 {
                                socialAuthVM.message = "전화번호를 10자 이상 입력해주세요."
                                socialAuthVM.showSocialSignupAlert = true
                            } else {
                                socialAuthVM.socialSignUp(email: email, userName: userName, nickname: nickname, mobile: mobile, loginMethod: socialAuthVM.APILoginMethod, socialID: socialAuthVM.socialID )
                            }
                        }
                        // 회원가입 결과 알림: 확인 버튼 터치 시 로그인 화면으로 이동
                        .alert("소셜 로그인", isPresented: $socialAuthVM.showSocialSignupAlert) {
                            Button("확인") {
                                if socialAuthVM.socialSignupSucceeded {
                                    navigateToUploadProfileImageView = true
                                    socialAuthVM.socialSignupSucceeded = false
                                }
                            }
                        } message: {
                            Text(socialAuthVM.message)
                        }
                        .navigationDestination(isPresented: $navigateToUploadProfileImageView) {
                            UploadProfileImageView(navigateToUploadProfileImageView: $navigateToUploadProfileImageView, afterSignup: true, userIDGiven: socialAuthVM.userID)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SocialSignUpView(navigateToSocialSignUp: .constant(true))
        .environmentObject(AuthViewModel())
        .environmentObject(SocialAuthViewModel())
}
