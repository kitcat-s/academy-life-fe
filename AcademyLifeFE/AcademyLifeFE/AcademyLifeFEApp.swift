import SwiftUI
import KakaoSDKCommon

@main
struct AcademyLifeFEApp: App {
    // 전역 environment object로 instancing해 중복 코드 제거
    @StateObject var authVM = AuthViewModel()
    @StateObject var notiVM = NotificationViewModel()
    @StateObject var attendanceVM = AttendanceViewModel()
    @StateObject var commonVM = CommonDetailCodeViewModel()
    @StateObject var courseVM = CourseViewModel()
    @StateObject var postVM = PostViewModel()
    @StateObject var commentVM = CommentViewModel()
    @StateObject var socialAuthVM = SocialAuthViewModel()
    @StateObject var teacherVM = TeacherViewModel()
    @StateObject var studentVM = StudentViewModel()
    @StateObject var userVM = UserViewModel()
    @StateObject var chatbotVM = ChatbotViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                SplashScreenView()
                    .onAppear {
                        // 로딩 시간 제어 (예: API 호출, 초기 설정)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                ContentView()
                    .environmentObject(authVM)
                    .environmentObject(notiVM)
                    .environmentObject(attendanceVM)
                    .environmentObject(commonVM)
                    .environmentObject(courseVM)
                    .environmentObject(postVM)
                    .environmentObject(commentVM)
                    .environmentObject(socialAuthVM)
                    .environmentObject(teacherVM)
                    .environmentObject(studentVM)
                    .environmentObject(userVM)
                    .environmentObject(chatbotVM)
            }
        }
    }
}

struct SplashScreenView: View {
    //    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            Image("LaunchLogo") // LaunchLogo는 Assets에 추가된 이미지 이름
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200) // 크기 조정
            //                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        //                        scale = 1.0
                        opacity = 1.0
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 카카오 로그인
        KakaoSDK.initSDK(appKey: AppConfig.apiKeyKakao)
        
        // Push Notification
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermission()  // 이거 호출해서 '알림 권한' 허용하도록 요청
        return true
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            var token:String = ""
            
            for i in 0..<deviceToken.count {
                token += String(format:"%02.2hhx", deviceToken[i] as CVarArg)
            }
            
            UserDefaults.standard.set(token, forKey: "deviceToken")
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let info = response.notification.request.content.userInfo
            print("AcademyLife didReceive >> ", info["name"] ?? "")
            completionHandler()
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let info = notification.request.content.userInfo
            print("AcademyLife willPresent >> ", info["name"] ?? "")
            completionHandler([.banner, .sound])
        }
        
    }
    
    
}
