//
//  PageHeading.swift
//  Academy-Life
//
//  Created by 서희재 on 11/20/24.
//

import SwiftUI

struct PageHeading: View {
    var title: String
    var bottomPaddng: Int = 48
    
    var body: some View {
        Text(title)
            .font(.system(size: 23))
            .foregroundStyle(Color.timiBlack)
            .bold()
            .padding(.top, 28)
            .padding(.bottom, CGFloat(bottomPaddng))
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    PageHeading(title: "로그인")
}
