import SwiftUI
import UIKit



struct settingsView: View {
     @AppStorage("appearance") private var selectedAppearance: Appearance = .system
    @AppStorage("userIsInternal") var isinternaluser = false
    @AppStorage("oldDesignEnabled") var oldDesignIsEnabled = false
    
    @ObservedObject var model: TextFileReaderModel = TextFileReaderModel(filename: "Terms")
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
    let osVersion = UIDevice.current.systemVersion
    let osName = UIDevice.current.systemName

    
    //restrictions
    @AppStorage("allowedToPost") var isAllowedToPost = true
    @AppStorage("modifyAccountSettings") var modifyAccountSettings = true
    @AppStorage("allowedToInteract") var allowedToInteractWithPosts = true
    @AppStorage("allowedToSendDM") var allowedToSendDM = true
    @AppStorage("allowedToPostMedia") var allowedToPostMedia = true
    @AppStorage("allowedToViewProfiles") var allowedToViewProfiles = true
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section() {
                        VStack(alignment: .center) {
                            
                            
                            HStack(alignment: .center ){
                                Image("icon")
                                    .resizable()
                                    .frame(width: 65, height: 65)
                                    .cornerRadius(15)
                                
                                VStack(alignment: .leading) {
                                    Text("Yapple Alpha")
                                        .font(.title)
                                        .bold()
                                    Text("Version: 0.2")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                    Text("\(osName) Version: \(osVersion)")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                    Text("\(osName) Build Number: \(BuildNumber?.ProductBuildVersion ?? "")")
                                        .font(.caption)
                                        .foregroundStyle(Color.secondary)
                                    
                                }
                                Spacer()
                            }
                            Text("Made With \(Image(systemName: "heart.fill")) By AndreTechGuy \nAll Glory To God")
                                .multilineTextAlignment(.center)
                        }
                    }
                    Section(header: Text("Appereance")){
                        Picker(selection: $selectedAppearance) {
                            ForEach(Appearance.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    Color.purple
                                    Image(systemName: "moon.fill")
                                        .font(.title2.weight(.bold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                                Text("Theme")
                            }
                        }
                        
                        //app icon
                        NavigationLink {
                            Text("theme settings")
                        } label: {
                            ZStack {
                                Color.black
                                Image(systemName: "app")
                                    .font(.title2.weight(.semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            Text("App Icon")
                        }
                    }
                    //notif settings
                    Section(header: Text("Privacy")) {
                        NavigationLink {
                            NotifSettingsView()
                        } label: {
                            ZStack {
                                Color.gray
                                Image(systemName: "bell.fill")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            Text("Notification Settings")
                        }
                        NavigationLink {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(model.data).frame(maxWidth: .infinity)
                                }
                                .padding()
                                .navigationBarTitle("Terms Of Service")
                            }
                        } label: {
                            ZStack {
                                Color.indigo
                                Image(systemName: "info.circle.text.page")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            Text("Terms Of Service")
                        }
                        NavigationLink {
                            Text("Data Collection Terms Will Go Here")
                        } label: {
                            ZStack {
                                Color.blue
                                Image(systemName: "hand.raised.fill")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            Text("Data Collection")
                        }
                    }
                    
                    Section(header: Text("Account"), footer: !modifyAccountSettings ? AnyView(Text("Modifying Account Info Is Unavailable Due To Restrictions")) : AnyView(EmptyView())) {
                        if !modifyAccountSettings {
                            NavigationLink {
                                Text("Account Info")
                            } label: {
                                ZStack {
                                    Color.green
                                    Image(systemName: "person.fill")
                                        .font(.title2.weight(.bold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                                VStack(alignment: .leading) {
                                    Text("Account Info")
                                }
                            }
                            .disabled(true)
                        } else {
                            NavigationLink {
                                Text("Account Info")
                            } label: {
                                ZStack {
                                    Color.green
                                    Image(systemName: "person.fill")
                                        .font(.title2.weight(.bold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                                VStack(alignment: .leading) {
                                    Text("Account Info")
                                }
                            }
                        }

                        NavigationLink {
                            List {
                                if isAllowedToPost == false {
                                    Text("Posting Not Allowed")
                                }
                                if modifyAccountSettings == false {
                                    Text("Modifying Account Settings Not Allowed")
                                }
                                if allowedToInteractWithPosts == false {
                                    Text("Interacting With Posts Not Allowed")
                                }
                                if allowedToSendDM == false {
                                    Text("Sending DMs Not Allowed")
                                }
                                if allowedToPostMedia == false {
                                    Text("Using Media In Posts Not Allowed")
                                }
                                if allowedToViewProfiles == false {
                                    Text("Viewing Profiles Not Allowed")
                                }
                            } 
                        } label: {
                            ZStack {
                                Color.red
                                Image(systemName: "nosign")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            VStack(alignment: .leading) {
                                Text("Account Restrictions")
                            }
                        }
                        NavigationLink {
                            Text("Verification")
                        } label: {
                            ZStack {
                                Color.blue
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.title2.weight(.bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            VStack(alignment: .leading) {
                                Text("Verification")
                            }
                        }
                    }
                    
                    //internal settings
                    if isinternaluser {
                        Section(header: Text("Internal")) {
                            NavigationLink {
                                List {
                                    Toggle(isOn: $oldDesignIsEnabled) {
                                        Text("Enable Old UI")
                                    }
                                }
                            } label: {
                                ZStack {
                                    Color.blue
                                    Image(systemName: "gear")
                                        .font(.title2.weight(.semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                                Text("Internal Settings")
                            }
                        }
                    }
                    Section(header: Text("Danger Zone")) {
                        Button {
                            print("Delete Account Button Pressed")
                        } label: {
                            HStack {
                                ZStack {
                                    Color.red
                                    Image(systemName: "trash.fill")
                                        .font(.title2.weight(.bold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 30, height: 30)
                                .cornerRadius(5)
                                Text("Delete My Account")
                            }
                        }
                        .foregroundStyle(Color.red)
                    }
                }
                .navigationTitle("Settings")
            }
        }
        .onAppear{
            readPlist()
        }
        .preferredColorScheme(colorScheme)
    }
       
}

enum Appearance: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}
