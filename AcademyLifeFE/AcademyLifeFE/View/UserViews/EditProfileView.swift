//
//  EditProfileView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/25/24.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: Field?
    enum Field {
        case userName, nickname, mobile
    }
    
    var body: some View {
        
        VStack {
            PageHeading(title: "프로필 변경")
            ScrollView{
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "이메일", label: "이메일", text: $userVM.user.email, isDisabled: true)
                    CustomTextField(placeholder: "이름을 입력해주세요", label: "이름", text: $userVM.user.userName)
                        .focused($focusedField, equals: .userName)
                        .onSubmit {
                            focusedField = .nickname
                        }
                    CustomTextField(placeholder: "닉네임을 입력해주세요", label: "닉네임", text: $userVM.user.nickname)
                        .focused($focusedField, equals: .nickname)
                        .onSubmit {
                            focusedField = .mobile
                        }
                    CustomTextField(placeholder: "전화번호를 입력해주세요", label: "전화번호", text: $userVM.user.mobile)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .mobile)
                }.padding(.bottom, 28)
                VStack(spacing: 16) {
                    WideButton(title: "저장하기", bgColor: .accentDefault) {
                        userVM.isEditSucceeded = false
                        if userVM.user.userName.isEmpty || userVM.user.nickname.isEmpty || userVM.user.mobile.isEmpty {
                            userVM.message = "모든 항목을 입력해주세요."
                            userVM.showEditProfileAlert = true
                        } else if userVM.user.mobile.count < 10 {
                            userVM.message = "전화번호를 10자 이상 입력해주세요."
                            userVM.showEditProfileAlert = true
                        } else {
                            userVM.editProfile(userName: userVM.user.userName, nickname: userVM.user.nickname, mobile: userVM.user.mobile)
                        }
                    }
                    .alert("프로필 변경", isPresented: $userVM.showEditProfileAlert) {
                        Button("확인") {
                            if userVM.isEditSucceeded {
                                userVM.showEditProfileAlert = false
                                userVM.isEditSucceeded = false
                                dismiss()
                            }
                        }
                    } message: {
                        Text(userVM.message)
                    }
                    .padding(.bottom, 40)
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .onAppear {
                userVM.getUserInfo(userIDGiven: nil)
            }
        }
    }
    
}

#Preview {
    EditProfileView()
        .environmentObject(UserViewModel())
}
