//
//  SmallButton.swift
//  timi-not-pull-ver
//
//  Created by SeYeong's MacBook on 11/16/24.
//

import SwiftUI

struct SmallImageButtonView: View {
    var btnText: String
    var action: () -> Void
    var strSystemImage: String
    var iconColor: UIColor = .accent
    var iConManualPosition: Int = 0
    
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                VStack {
                    Image(systemName: strSystemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 26)
                        .foregroundStyle(Color(iconColor))
                        .padding(.leading, CGFloat(iConManualPosition))
                        .padding(.bottom, 4)
                    Text(btnText)
                        .foregroundStyle(.timiBlack)
                        .font(.system(size: 13))
                }
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    SmallImageButtonView(btnText: "수정", action: {
        print("edit button")
    }, strSystemImage: "slider.horizontal.3", iconColor: .black)
    SmallImageButtonView(btnText: "수정", action: {
        print("edit button")
    }, strSystemImage: "door.left.hand.open", iconColor: .black, iConManualPosition: 10)
}
