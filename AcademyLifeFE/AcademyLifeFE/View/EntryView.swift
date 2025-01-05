import SwiftUI

struct EntryView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @AppStorage("isLoggedIn") private var isLoggedInAtAppStorage: Bool?
    @State private var isLoggedIn: Bool?
    
    var body: some View {
        VStack {
            if isLoggedIn == true {
                MainView()
            } else {
                LoginView()
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: isLoggedIn)
            .onAppear {
                isLoggedIn = isLoggedInAtAppStorage
            }
            .onChange(of: isLoggedInAtAppStorage, perform: { newValue in
                withAnimation {
                    isLoggedIn = newValue
                }
            })
    }
}

#Preview {
    EntryView()
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationViewModel())
        .environmentObject(AttendanceViewModel())
        .environmentObject(CommonDetailCodeViewModel())
        .environmentObject(CourseViewModel())
        .environmentObject(PostViewModel())
        .environmentObject(CommentViewModel())
        .environmentObject(SocialAuthViewModel())
        .environmentObject(TeacherViewModel())
        .environmentObject(StudentViewModel())
}
