//
//  LoginView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var socialAuthVM: SocialAuthViewModel
    @State var navigateToSignUp = false
    @State var navigateToSocialSignUp = false
    @State var email: String = ""
    @State var password: String = ""
    @AppStorage("isLoggedIn") private var isLoggedInAtAppStorage: Bool?
    @State private var isLoggedIn: Bool = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    PageHeading(title: "로그인")
                        .padding(.top, 40)
                    VStack {
                        VStack(spacing: 20) {
                            CustomTextField(placeholder: "이메일을 입력해주세요", label: "이메일", text: $email)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .email)
                                .keyboardType(.emailAddress)
                                .onSubmit {
                                    focusedField = .password
                                }
                            CustomTextField(placeholder: "비밀번호를 입력해주세요", label: "비밀번호", text: $password, isSecured: true)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .password)
                        }
                        .padding(.bottom, 28)
                        VStack(spacing: 16) {
                            WideButton(title: "로그인", bgColor: .accentDefault, textColor: .timiBlack) {
                                if email.isEmpty {
                                    focusedField = .email
                                } else if password.isEmpty {
                                    focusedField = .password
                                } else {
                                    focusedField = nil
                                    authVM.login(email: email, password: password)
                                }
                            }
                            .alert("로그인", isPresented: $authVM.showLoginAlert) {
                                Button("확인") {
                                    authVM.showLoginAlert = false
                                }
                            } message: {
                                Text(authVM.message)
                            }
                            WideButton(title: "회원가입", bgColor: .accentLight, textColor: .accentDark) {
                                navigateToSignUp = true
                            }
                            .navigationDestination(isPresented: $navigateToSignUp) {
                                SignUpView(navigateToSignUp: $navigateToSignUp)
                            }
                        }
                    }
                    VStack(spacing: 20) {
                        Text("또는 소셜 회원가입/로그인")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .foregroundStyle(.timiBlack)
                        HStack() {
                            SocialLoginAppleView()
                            SocialLoginKakaoView()
                        }
                    }
                    .navigationDestination(isPresented: $navigateToSocialSignUp ) {
                        SocialSignUpView(navigateToSocialSignUp: $navigateToSocialSignUp)
                    }
                    .navigationTitle("로그인")
                    // 소셜 로그인 알림: 회원이 없을 때 나오는 알림 - 확인 버튼 터치 시 소셜 회원가입 화면으로 이동
                    .alert("소셜 로그인", isPresented: $socialAuthVM.showSocialLoginAlert) {
                        Button("확인") {
                            if isLoggedIn != true {
                                navigateToSocialSignUp = true
                            }
                            socialAuthVM.showSocialLoginAlert = false
                        }
                    } message: {
                        Text(socialAuthVM.message)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            // 로그인 화면이 로딩될 시 isLoggedIn 변수 초기화하기
            if isLoggedInAtAppStorage != true {
                isLoggedIn = false
            }
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
        .environmentObject(SocialAuthViewModel())
}
