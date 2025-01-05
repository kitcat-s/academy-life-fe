//
//  NotificationRowView.swift
//  Academy-Life
//
//  Created by 서희재 on 11/22/24.
//

import SwiftUI

let sampleNoti = Notification(id: 5, notiGroupCd: 2, courseID: 4, courseName: "[Sample] iOS", notiTitle: "면접증빙서류", notiContents: Optional("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin.?"), postID: 5, createdAt: "2024-11-21T08:38:37.916Z")

struct NotificationRowView: View {
    @EnvironmentObject var notiVM: NotificationViewModel
    var notification: Notification
    
    var body: some View {
        let createdAt = formatStringToDate(notification.createdAt)
        let postID = notification.postID
        
        NavigationLink(
            destination:
                PostDetailView(
                    courseID: notification.courseID,
                    postID: postID,
                    cmDtCd: notification.notiGroupCd == 1 ? 1 : 2
                )
                .navigationBarTitleDisplayMode(.inline)
        ) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack {
                        switch notification.notiGroupCd {
                        case 1:
                            Text("공지사항")
                        default:
                            Text("문의게시판")
                        }
                    }
                    .bold()
                    .padding(.horizontal,  6)
                    .padding(.vertical,4)
                    .foregroundStyle(.accentDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.accentDark, lineWidth: 2)
                    )
                    .font(.system(size: 13))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    Spacer()
                    Text("\(dateFormatter.string(from: createdAt))")
                        .font(.system(size: 13))
                        .foregroundStyle(.timiGray)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(notification.notiTitle)
                        .font(.system(size: 16))
                        .bold()
                        .lineLimit(1)
                    if (notification.notiContents != nil) {
                        Text(notification.notiContents!)
                            .font(.system(size: 14))
                            .lineLimit(1)
                    }
                    Text("\(notification.courseName) 과정")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .foregroundStyle(.timiBlack)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NotificationRowView(notification: sampleNoti)
        .environmentObject(NotificationViewModel())
}
