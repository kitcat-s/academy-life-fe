//
//  SignUpView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var userName: String = ""
    @State var nickname: String = ""
    @State var mobile: String = ""
    @State var isTeacher: Bool = false
    @Binding var navigateToSignUp: Bool
    @FocusState private var focusedField: Field?
    @State var navigateToUploadProfileImageView = false
    
    enum Field {
        case email, password, confirmPassword, userName, nickname, mobile
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                PageHeading(title: !isTeacher ? "회원가입" : "신규 선생님 등록")
                
                ScrollView {
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
                            .onSubmit {
                                focusedField = .confirmPassword
                            }
                        CustomTextField(placeholder: "비밀번호를 한 번 더 입력해주세요", label: "비밀번호 확인", text: $confirmPassword, isSecured: true)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .confirmPassword)
                            .onSubmit {
                                focusedField = .userName
                            }
                        CustomTextField(placeholder: "이름을 입력해주세요", label: "이름", text: $userName)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .userName)
                            .onSubmit {
                                focusedField = .nickname
                            }
                        CustomTextField(placeholder: "닉네임을 입력해주세요", label: "닉네임", text: $nickname)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .nickname)
                        CustomTextField(placeholder: "전화번호를 입력해주세요", label: "전화번호", text: $mobile)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .mobile)
                            .onSubmit {
                                focusedField = .nickname
                            }
                    }
                    .padding(.bottom, 28)
                    VStack(spacing: 16) {
                        WideButton(title: !isTeacher ? "회원가입" : "선생님 등록", bgColor: .accentDefault) {
                            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || userName.isEmpty || nickname.isEmpty || mobile.isEmpty {
                                authVM.message = "모든 항목을 입력해주세요."
                                authVM.showSignUpAlert = true
                            } else if mobile.count < 10 {
                                authVM.message = "전화번호를 10자 이상 입력해주세요."
                                authVM.showSignUpAlert = true
                            } else {
                                authVM.signup(email: email, password: password, confirmPassword: confirmPassword, userName: userName, nickname: nickname, mobile: mobile, isTeacher: isTeacher)
                            }
                        }
                        .alert("회원가입", isPresented: $authVM.showSignUpAlert) {
                            Button("확인") {
                                if authVM.signupSucceeded {
                                    navigateToUploadProfileImageView = true
                                    authVM.signupSucceeded = false
                                }
                            }
                        } message: {
                            Text(authVM.message)
                        }
                        .padding(.bottom, 40)
                    }
                    .navigationDestination(isPresented: $navigateToUploadProfileImageView) {
                        UploadProfileImageView(navigateToUploadProfileImageView: $navigateToUploadProfileImageView, afterSignup: true, userIDGiven: authVM.userID)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
    }
}

#Preview {
    SignUpView(isTeacher: false, navigateToSignUp: .constant(true))
        .environmentObject(AuthViewModel())
        .environmentObject(SocialAuthViewModel())
}
