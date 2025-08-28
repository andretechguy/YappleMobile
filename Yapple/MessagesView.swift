import SwiftUI


struct MessagesView: View {
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
    @AppStorage("allowedToSendDM") var allowedToSendDM = true
    var body: some View {
        VStack(alignment: .center) {
            if !allowedToSendDM {
                Spacer()
                Image(systemName: "nosign")
                    .font(.system(size: 50, weight: .semibold))
                Text("You Are Unable To Send Messages Due To Restrictions")
                    .padding(.vertical)
                Spacer()
            } else {
                Spacer()
                Text("Coning Soon!")
                Spacer()
            }
        }
    }
}
