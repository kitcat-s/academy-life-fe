//
//  UploadProfileImageView.swift
//  Academy-Life
//
//  Created by 서희재 on 12/5/24.
//

import SwiftUI

struct UploadProfileImageView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Binding var navigateToUploadProfileImageView: Bool
    @Environment(\.dismiss) var dismiss
    var afterSignup = false
    var userIDGiven: Int
    
    @State var showUploadAlert = false
    @State var showPicker = false
    @State var images: [UIImage] = []
    @State var newImages: [UIImage] = []
    
    var body: some View {
        
        VStack(alignment: .center) {
            PageHeading(title: "프로필 이미지 등록")
            Spacer()
            VStack(alignment: .center, spacing: 20) {
                if let image = afterSignup ? images.first : (newImages.isEmpty ? userVM.images.first : newImages.first) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                } else {
                    ImagePlaceholder(imageSize: 160)
                }
            }
            .padding(.bottom, 16)
            Button {
                showPicker.toggle()
            } label: {
                Text("이미지 불러오기")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundStyle(.accentDark)
                    .background(.accentLight)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
            .sheet(isPresented: $showPicker) {
                ImagePicker(images: afterSignup ? $images : $newImages, selectionLimit: 1)
            }
            Spacer()
            VStack {
                let isEmpty = afterSignup ? images.isEmpty : newImages.isEmpty
                let selectedImage = afterSignup ? images.first : newImages.first

                WideButton(
                    title: "저장하기",
                    bgColor: isEmpty ? .timiGray : .accentDefault,
                    textColor: isEmpty ? .white : .timiBlack
                ) {
                    if let image = selectedImage {
                        userVM.uploadProfileImage(image: image, userIDGiven: userIDGiven)
                    }
                }
                .disabled(isEmpty)
                .alert("프로필 이미지 등록", isPresented: $userVM.showImageUploadAlert) {
                    Button("확인") {
                        dismiss()
                        userVM.showEditPasswordAlert = false
                        navigateToUploadProfileImageView = false
                    }
                } message: {
                    Text(userVM.message)
                }

            }
        }
        .onAppear {
            // 마이페이지에서 진입 시에는 API 호출해서 현재 프로필 이미지 가져오기
            if !afterSignup {
                userVM.getUserInfo(userIDGiven: nil)
            }
        }
    }
}

#Preview {
    UploadProfileImageView(navigateToUploadProfileImageView: .constant(true), afterSignup: false, userIDGiven: 16)
        .environmentObject(UserViewModel())
}
