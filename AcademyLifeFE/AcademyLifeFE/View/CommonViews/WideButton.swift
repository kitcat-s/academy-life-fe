//
//  WideButton.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI

struct WideButton: View {
    var title: String
    var showIcon = false // 아이콘 넣기 옵션
    var icon: String?
    var bgColor: Color = .accentColor
    var borderColor: Color = .clear
    var textColor: Color = .timiBlack
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            // 아이콘 넣기 옵션이 true이고 아이콘 이름이 전달돼야 아이콘 노출
            if showIcon, let iconName = icon {
                Image(systemName: iconName)
            }
            Text(title)
                .font(.system(size: 16))
                .bold()
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(bgColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(borderColor, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

#Preview {
    WideButton(title: "로그인") {}
    
}
