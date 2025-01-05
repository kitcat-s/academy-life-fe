//
//  SocialLoginAppleView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/26/24.
//

import SwiftUI
import AuthenticationServices

struct SocialLoginAppleView: View {
    @EnvironmentObject var socialAuthVM: SocialAuthViewModel
    @State var socialID: String = ""
    @State var email: String? // Optional
    @State var fullName: PersonNameComponents?  // Optional
    
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            // 애플 서버에 해당 회원이 있는지 검증하기
            switch result {
            case .success(let auth):
                if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                    // 있으면 소셜 로그인 함수에 태우기
                    socialID = credential.user
                    if let appleEmail = credential.email {
                        email = appleEmail
                    }
                    socialAuthVM.socialLogin(loginMethod: .apple, socialID: socialID)
                } else {
                    print("Failed to extract credential.")
                }
            case .failure(let error):
                print("Failure: \(error.localizedDescription)")
            }
        }
        .frame(width: 50, height: 50)
        .overlay(alignment: .center, content: {
            // 애플 회원 가입 버튼의 터치 영역을 가리지 않으면서 기존 버튼 텍스트를 가리기 위해 두꺼운 아웃라인 추가
            RoundedRectangle(cornerRadius: 15)
                .stroke(.black, lineWidth: 80)
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
                .frame(width: 18)
                .padding(.bottom, 3)
        })
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    SocialLoginAppleView()
        .environmentObject(SocialAuthViewModel())
        .environmentObject(AuthViewModel())
}
