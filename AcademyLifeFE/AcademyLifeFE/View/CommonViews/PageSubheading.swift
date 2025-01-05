//
//  PageSubheading.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/11/24.
//

import SwiftUI

struct PageSubheading: View {
    var text: String
    var bottomPaddng: Int = 20
    
    var body: some View {
        Text(text)
            .font(.system(size: 18))
            .foregroundStyle(Color.timiBlack)
            .bold()
            .padding(.bottom, CGFloat(bottomPaddng))
    }
}

#Preview {
    PageSubheading(text: "기타")
}
