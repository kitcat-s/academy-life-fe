//
//  SocialLoginKakao.swift
//  Academy-Life
//
//  Created by 서희재 on 11/28/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKUser

struct SocialLoginKakaoView: View {
    @EnvironmentObject var socialAuthVM: SocialAuthViewModel
    @State var socialID: String = ""
    
    var body: some View {
        Button {
            authViaKakao()
        } label: {
            Image("kakao_login_large_wide")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    // 카카오 앱/웹으로 로그인 시키기
    func authViaKakao() {
        // 카카오톡 어플이 사용 가능하면 앱으로 이동하기
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    fetchUserInfo()
                }
            }
        } else {
            // 아니면 웹뷰로 진행하기
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    fetchUserInfo()
                }
            }
        }
    }
    
    // 카카오 서버에 해당 회원이 있는지 검증하기
    fileprivate func fetchUserInfo() {
        UserApi.shared.me { user, error in
            if let error {
                print(error.localizedDescription)
            } else {
                // 있으면 소셜 로그인 함수에 태우기
                if let socialID = user?.id {
                    socialAuthVM.socialLogin(loginMethod: .kakao, socialID: "\(socialID)")
                }
            }
        }
    }
}

#Preview {
    SocialLoginKakaoView()
        .environmentObject(SocialAuthViewModel())
}
