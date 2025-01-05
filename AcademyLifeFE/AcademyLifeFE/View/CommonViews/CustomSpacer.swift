//
//  CustomSpacer.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/12/24.
//

import SwiftUI

struct CustomSpacer: View {
    var body: some View {
        Rectangle()
            .frame(width: 80, height: 1)
            .foregroundColor(.clear)
    }
}

#Preview {
    CustomSpacer()
}
