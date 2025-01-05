//
//  ProfileImageView.swift
//  AcademyLifeFE
//
//  Created by 서희재 on 12/6/24.
//

import SwiftUI

let sampleUser = User(userID: 16, email: "kiApple@a.com", authCd: "AUTH02", userName: "희재 애플", nickname: "희재 애플", mobile: "111", kakao: nil, apple: Optional("000017.81e31d45761d465093a0971fbe872d52.0212"), profileImage: Optional(":profileImages:0-logo-dark.png"))

struct ProfileImageView: View {
    @EnvironmentObject var userVM: UserViewModel
    let userID: Int
    let profileImage: String
    let imageSize: Int
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://\(AppConfig.blobContainerDomain)/academylife/\(profileImage)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CGFloat(imageSize), height: CGFloat(imageSize))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
            } placeholder: {
                ImagePlaceholder(imageSize: imageSize, foregroundColor: .timiGray.opacity(0.5))
            }
        }
        .onAppear {
        }
    }
}

#Preview {
    ProfileImageView(userID: sampleUser.userID, profileImage: sampleUser.profileImage ?? "", imageSize: 160)
        .environmentObject(UserViewModel())
}
