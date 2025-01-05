//
//  DateDisplay.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/11/24.
//

import SwiftUI

struct DateDisplay: View {
    var today: Date = Date()
    
    var body: some View {
        Text(formatDate(today))
            .padding(.horizontal)
            .padding(.vertical, 6)
            .font(.system(size: 14))
            .foregroundStyle(.timiBlackLight)
            .background(Color.timiTextField)
            .cornerRadius(20)
            .padding(.bottom, 16)
    }
}

#Preview {
    DateDisplay()
}
