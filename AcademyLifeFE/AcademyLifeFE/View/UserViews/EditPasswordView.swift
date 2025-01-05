//
//  EditPasswordView.swift
//  Academy-Life
//
//  Created by 서희재 on 12/4/24.
//

import SwiftUI

struct EditPasswordView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State var password = ""
    @State var confirmPassword = ""
    
    @FocusState private var focusedField: Field?
    enum Field {
        case password, passwordConfirm
    }
    
    var body: some View {
        VStack {
            PageHeading(title: "비밀번호 변경")
            ScrollView{
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "비밀번호를 입력해주세요", label: "비밀번호", text: $password, isSecured: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            focusedField = .passwordConfirm
                        }
                    CustomTextField(placeholder: "비밀번호를 한 번 더 입력해주세요", label: "비밀번호 확인", text: $confirmPassword, isSecured: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .passwordConfirm)
                }.padding(.bottom, 28)
                VStack(spacing: 16) {
                    WideButton(title: "저장하기", bgColor: password.isEmpty || confirmPassword.isEmpty ? .timiGray : .accentDefault, textColor: password.isEmpty || confirmPassword.isEmpty ? .white : .timiBlack) {
                        focusedField = nil
                        userVM.editPassword(password: password, confirmPassword: confirmPassword)
                    }
                    .disabled(password.isEmpty || confirmPassword.isEmpty)
                    .alert("비밀번호 변경", isPresented: $userVM.showEditPasswordAlert) {
                        Button("확인") {
                            if userVM.isEditSucceeded {
                                userVM.showEditPasswordAlert = false
                                dismiss()
                                userVM.isEditSucceeded = false
                            }
                        }
                    } message: {
                        Text(userVM.message)
                    }
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                userVM.getUserInfo(userIDGiven: nil)
            }
        }
    }
}

#Preview {
    EditPasswordView()
        .environmentObject(UserViewModel())
}
