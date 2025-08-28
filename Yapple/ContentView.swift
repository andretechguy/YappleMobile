import SwiftUI

struct ContentView: View {
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
    @State private var showingSettingsSheet = false
    @State private var showingExportSheet = false
    
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
              VStack{
                  
              }
              .toolbar {
                  ToolbarItem {
                      if isAuthenticated {
                          Menu("\(Image(systemName: "gear"))") {
                              Button("Settings", systemImage: "bell.badge.fill"){
                                  showingSettingsSheet.toggle() 
                              }
                              
                              Button("Export iPA (Advanced Users Only!)", systemImage: "square.and.arrow.up") {
                                  showingExportSheet.toggle()
                              }
                              
                              Button("Sign Out", systemImage: "person.crop.circle.fill.badge.xmark") {
                                  Task {
                                      try await supabase.auth.signOut()
                                      
                                  }
                              }
                          }
                          .padding()
                          .sheet(isPresented: $showingSettingsSheet) {
                              settingsView()
                          } 
                          .sheet(isPresented: $showingExportSheet ){
                              ExportView()
                          }
                          
                      } else {
                          Button("Sign In") {
                              showingSheet.toggle()
                          }
                          .padding()
                          .buttonStyle(.borderedProminent)
                          .sheet(isPresented: $showingSheet) {
                              AuthView()
                          } 
                          
                      }
                  }
              }
                TabView {
                    PostView()
                        .tabItem { Label("Home",systemImage: "house.fill") }
                        .tag(1)
                    
                    NotificationsView()
                        .tabItem { Label("Notifications",systemImage: "bell.fill") }
                        .tag(2)
                    AccountView()
                        .tabItem { Label("Account",systemImage: "person.fill") }
                        .tag(3)
                }
            }
            .environment(\.horizontalSizeClass, .compact)
            .task {
                for await state in await supabase.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
        } else {
            HStack {
                if isAuthenticated == true {
                    Menu("\(Image(systemName: "gear"))") {
                        Button("Settings", systemImage: "bell.badge.fill"){
                            showingSettingsSheet.toggle() 
                        }
                        
                        Button("Sign Out", systemImage: "person.crop.circle.fill.badge.xmark") {
                            Task {
                                try await supabase.auth.signOut()
                                
                            }
                        }
                    }
                    .padding()
                    .sheet(isPresented: $showingSettingsSheet) {
                        settingsView()
                    } 
                    
                } else {
                    Button("Sign In") {
                        showingSheet.toggle()
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showingSheet) {
                        AuthView()
                    } 
                    
                }
                
                
            }
            .task {
                for await state in await supabase.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
            TabView {
                PostView()
                    .tabItem { Label("Home",systemImage: "house.fill") }
                    .tag(1)
                
                NotificationsView()
                    .tabItem { Label("Notifications",systemImage: "bell.fill") }
                    .tag(2)
                AccountView()
                    .tabItem { Label("Account",systemImage: "person.fill") }
                    .tag(3)
                
            }
        }
    }
}
