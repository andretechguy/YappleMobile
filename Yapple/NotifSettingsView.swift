import SwiftUI
import UserNotifications

struct NotifSettingsView: View {
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
    @State private var notificationsEnabled = true
    @State private var authorized = Bool()
    
    var body: some View {
        VStack {
            if authorized {
                Toggle("Notifications" ,isOn: $notificationsEnabled) 
                 if notificationsEnabled {
                     Button ("Send Notification") {
                         requestAuthorization()  
                         sendNotification()
                     }
                     .padding()
                     .foregroundStyle(.white)
                     .background(Color(red: 0, green: 0, blue: 0.5))
                     .clipShape(Capsule())
                 } else {
                     
                 }
                
            } else {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 150))
                    .foregroundStyle(.purple, .white)
                Button("Allow Notifications") {
                    requestAuthorization()
                }
                .padding()
                .foregroundStyle(.white)
                .background(Color(red: 0, green: 0, blue: 0.5))
                .clipShape(Capsule())
            }
        }
    }
    func requestAuthorization () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings]) { success, _ in 
            if success{
                authorized = true
            } else {
                authorized = false
            }
        }
    }
    func sendNotification() {
        let customSound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "NSoundN.m4a"))
        let content = UNMutableNotificationContent()
        content.title = "New Post"
        content.body = "New post has been added, check it out!"
        content.sound = customSound
        
        let identifier = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest (identifier: identifier, content: content, trigger: trigger)
        for _ in (1...100) {
            UNUserNotificationCenter.current().add(request)
        } 
        print("Success")
    }
}
