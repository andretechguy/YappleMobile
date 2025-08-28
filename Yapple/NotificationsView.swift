import SwiftUI

struct NotificationsView: View {
    @AppStorage("appearance") private var selectedAppearance: Appearance = .system
    var colorScheme: ColorScheme? {
        switch selectedAppearance {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(0..<100) { _ in
                    NotificationCell()
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                
            }
        }
    }
}

struct NotificationCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                Text("Notifications will go here. Notifications will go here. Notifications will go here. Notifications will go here.Notifications will go here.")
                    .padding(.top, 10)
            }
            .padding(.vertical, 20)
        }
    }
}
