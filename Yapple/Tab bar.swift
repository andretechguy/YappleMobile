import SwiftUI



struct TabBarView: View {
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
    @AppStorage("Authenticated") var isAuthenticated = false
    @State private var showingSheet = false
    @Environment(\.dismiss) var dismissSettings
    @State var showingSettingsSheet = false
    @State var showingExportSheet = false
    @State private var selectedIndex = 0
    let tabbarItems = ["house.fill", "at", "bell.fill", "envelope.fill", "person.fill"] // System icon names
    

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all) // Background color

            // Content views for each tab
            switch selectedIndex {
            case 0:
                PostView()
                    .safeAreaInset(edge: .top) {
                        topBar(showingSettingsSheet: $showingSettingsSheet, showingExportSheet: $showingExportSheet )
                    }
            case 1:
                AccTabView()
                    .safeAreaInset(edge: .top) {
                        topBar(showingSettingsSheet: $showingSettingsSheet, showingExportSheet: $showingExportSheet)
                    }
            case 2:
                NotificationsView()
                    .safeAreaInset(edge: .top) {
                        topBar(showingSettingsSheet: $showingSettingsSheet, showingExportSheet: $showingExportSheet)
                    }
            case 3:
                MessagesView()
                    .safeAreaInset(edge: .top) {
                        topBar(showingSettingsSheet: $showingSettingsSheet, showingExportSheet: $showingExportSheet)
                    }
            case 4:
                AccountView()
                    .safeAreaInset(edge: .top) {
                        topBar(showingSettingsSheet: $showingSettingsSheet, showingExportSheet: $showingExportSheet)
                    }
            default:
                PostView()
                    .safeAreaInset(edge: .top) {
                        topBar(showingSettingsSheet: $showingSettingsSheet, showingExportSheet: $showingExportSheet)
                    }
            }
            VStack {
               
                    Spacer()
                    CustomTabBar(selectedIndex: $selectedIndex, items: tabbarItems)
                    
                }
            .sheet(isPresented: $showingSettingsSheet) {
                settingsView()
            } 
            .sheet(isPresented: $showingExportSheet ){
                ExportView()
            }
        }
    }
}

struct CustomTabBar: View {
     @Environment(\.colorScheme) var colorScheme
    @Binding var selectedIndex: Int
    var items: [String]

    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.snappy) {
                        selectedIndex = index
                    }
                }) {
                    VStack {
                        Image(systemName: items[index])
                            .font(.system(size: 26))
                            .foregroundColor(selectedIndex == index ? (colorScheme == .dark ? Color.white : Color.black) : .gray)
                       
                    }
                    .padding(.vertical, 15)
                }
                .hoverEffect(.lift)
                .frame(maxWidth: 120)
            }
        }
        .background(BlurView())
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 15)
                .stroke((colorScheme == .dark ? Color.white : Color.black), lineWidth: 2)
        )
        .cornerRadius(15)
        .padding(.horizontal, 15)
        .padding(.bottom, 8)
        
    }
}

struct topBar: View {
    @Binding var showingSettingsSheet: Bool
    @Binding var showingExportSheet: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack{
            Spacer()
            Image("noBackDark")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
                .padding(.trailing, 15)
            Menu {
                    Button("Settings", systemImage: "gear"){
                        showingSettingsSheet.toggle() 
                    }
                    
                Menu("Advanced") {
                    Button("Export iPA (Advanced Users Only!)", systemImage: "square.and.arrow.up") {
                        showingExportSheet.toggle()
                    }
                    Button("Crash App", systemImage: "xmark.app.fill") {
                        exit(0)
                    }
                }
                    
                    Button("Sign Out", systemImage: "person.crop.circle.fill.badge.xmark") {
                        Task {
                            try await supabase.auth.signOut()
                            
                        }
                    }
                    .foregroundStyle(Color.red)
           } label: {
                VStack {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 26))
                }
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .padding(.vertical, 25)
            }
            .hoverEffect(.lift)
            .frame(maxWidth: 120)            

        }
        .background(BlurView())
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 15)
                .stroke((colorScheme == .dark ? Color.white : Color.black), lineWidth: 2)
        )
        .frame(maxWidth: 505)
        .cornerRadius(15)
        .padding(.horizontal, 15)
        .padding(.top, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
