//
//  CustomTextField.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI

struct CustomTextField: View {
    /* 뷰 호출 시 유동적으로 지정되도록 */
    var placeholder: String
    var label: String = ""
    @Binding var text: String // 상위 뷰에서 지정이 되므로
    var isSecured: Bool = false // 값을 넘겨주지 않으면 false가 되도록 지정
    var isLabelShowing: Bool = true
    var isDisabled: Bool = false
    var isRequired: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if isLabelShowing {
                HStack {
                    Text(label)
                        .font(.system(size: 15))
                    if isRequired {
                        Image(systemName: "asterisk")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 6)
                            .foregroundStyle(.accentDark)
                            .padding(.bottom, 4)
                    }
                }
            }
            Group {
                if isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.system(size: 15))
            .padding()
            .background(!isDisabled ? .timiTextField : .white)
            .foregroundStyle(!isDisabled ? .timiBlack : .timiGray)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(!isDisabled ? .clear : .timiGray.opacity(0.5), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .textInputAutocapitalization(.never) // 첫 글자 대문자 변경 비활성화
            .autocorrectionDisabled(true) // 자동 완성 비활성화
            .onTapGesture {
                dismissKeyboard()
            }
            .disabled(isDisabled)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTextField(placeholder: "아이디를 입력해주세요", label: "이메일", text: .constant("wizard"), isDisabled: true)
    CustomTextField(placeholder: "비밀번호를 입력해주세요", label: "비밀번호", text: .constant("wizard"), isSecured: true)
}
