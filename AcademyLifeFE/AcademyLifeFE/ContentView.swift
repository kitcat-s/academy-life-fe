import SwiftUI

struct ContentView: View {
    var body: some View {
        EntryView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
