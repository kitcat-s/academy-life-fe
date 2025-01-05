import SwiftUI

struct MainView: View {
    @EnvironmentObject var attendanceVM: AttendanceViewModel

    @State private var selectedTab = 1
    @State private var showLocationAuthAlert = false
    @State private var alertLocationAuthMessage = ""
    
    @AppStorage("authCd") var authCd: String?

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedTab) {
                    // 알림 탭
                    NotificationListView().tabItem {
                        Image(systemName: "megaphone.fill")
                        Text("알림")
                    }.tag(0)

                    // 출석체크 탭
                    AttendanceView().tabItem {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                        Text("출석체크")
                    }.tag(1)
                    
                    //AI 탭
                    ChatbotView().tabItem {
                        Image(systemName: "ev.plug.dc.nacs.fill")
                        Text("AI도우미")
                    }.tag(2)
                    
                    // 마이페이지 탭
                    MyPageView().tabItem {
                        Image(systemName: "person.fill")
                        Text("마이페이지")
                    }.tag(3)
                }
                .onAppear {
                    if let authCd, authCd == "AUTH02" { // 학생일 때만
                        DispatchQueue.main.async {
                            attendanceVM.checkAndRequestLocationAuthorization { message in
                                if let message = message {
                                    alertLocationAuthMessage = message
                                    showLocationAuthAlert = true
                                } else {
                                    attendanceVM.startMonitoring()
                                }
                            }
                        }
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    if let authCd, authCd == "AUTH02" { // 학생 일 때만
                        if newValue == 1 { // AttendanceView 선택 시
                            DispatchQueue.main.async {
                                attendanceVM.checkAndRequestLocationAuthorization { message in
                                    if let message = message {
                                        alertLocationAuthMessage = message
                                        showLocationAuthAlert = true
                                    } else {
                                        attendanceVM.startMonitoring()
                                    }
                                }
                            }
                        } else { // 다른 뷰 선택 시 Beacon 모니터링 종료
                            DispatchQueue.main.async {
                                attendanceVM.stopMonitoring()
                            }
                        }
                    }
                }
                //                .toolbar {
                //                    // 로그아웃
                //                    ToolbarItem(placement: .topBarLeading) {
                //                        Button {
                //                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                //                            UserDefaults.standard.removeObject(forKey: "userID")
                //                            UserDefaults.standard.synchronize()
                //                        } label: {
                //                            Image(systemName: "rectangle.portrait.and.arrow.right")
                //                        }
                //                    }
                //                }
            }
            .alert(isPresented: $showLocationAuthAlert) {
                Alert(
                    title: Text("권한 필요"),
                    message: Text(alertLocationAuthMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
}

#Preview {
    MainView()
}
