//
//  ImagePlaceholder.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/6/24.
//

import SwiftUI

struct ImagePlaceholder: View {
    var imageSize: Int = 30
    var foregroundColor: Color = .timiWhiteDark
    
    var body: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .foregroundStyle(foregroundColor)
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
            .clipShape(RoundedRectangle(cornerRadius: .infinity))
    }
}

#Preview {
    ImagePlaceholder()
}
