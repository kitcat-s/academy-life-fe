//
//  CourseDateDisplay.swift
//  AcademyLifeFE
//
//  Created by Heejae Seo on 12/17/24.
//

import SwiftUI

struct CourseDateDisplay: View {
    var startDate: String
    var endDate: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(startDate)")
            Text(" ~ \(endDate)")
        }
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
    CourseDateDisplay(startDate: "2024-10-19", endDate: "2024-12-19")
}
