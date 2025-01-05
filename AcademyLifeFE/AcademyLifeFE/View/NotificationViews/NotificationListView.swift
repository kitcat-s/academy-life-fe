//
//  NotificationListView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/22/24.
//

import SwiftUI

struct NotificationListView: View {
    @EnvironmentObject var notiVM: NotificationViewModel
    let userID = UserDefaults.standard.integer(forKey: "userID")
    
    var body: some View {
        NavigationStack {
            PageHeading(title: "알림", bottomPaddng: 16)
            DateDisplay()
            
            if notiVM.notifications.count > 0 {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(notiVM.notifications) { notification in
                            NotificationRowView(notification: notification)
                        }
                        .padding(.top)
                    }
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.timiTextField)
            } else {
                VStack {
                    Text("아직 받은 알림이 없어요.")
                        .foregroundStyle(.timiBlack)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.timiTextField)
            }
        }
        .onAppear {
            notiVM.fetchNotifications(userID: userID)
        }
    }
}

#Preview {
    NotificationListView()
        .environmentObject(NotificationViewModel())
}
