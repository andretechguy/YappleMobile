import SwiftUI

struct AppView: View {
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
    @AppStorage("oldDesignEnabled") var oldDesignIsEnabled = false
    @AppStorage("userAgreedToTerms") var termsAccepted = false
    
    //restrictions
    @AppStorage("allowedToPost") var isAllowedToPost = true
    @AppStorage("modifyAccountSettings") var modifyAccountSettings = true
    @AppStorage("allowedToInteract") var allowedToInteractWithPosts = true
    @AppStorage("allowedToSendDM") var allowedToSendDM = true
    @AppStorage("allowedToPostMedia") var allowedToPostMedia = true
    @AppStorage("allowedToViewProfiles") var allowedToViewProfiles = true
    var body: some View {
        Group {
            if termsAccepted == false {
                TermsView()
            } else if isAuthenticated && oldDesignIsEnabled {
                ContentView()
            } else if isAuthenticated {
                TabBarView()
            } else {
                AuthView()
            }
        }
        .task {
            for await state in await supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    isAuthenticated = state.session != nil
                }
            }
        }
        .task {
            do {
                let currentUser = try await supabase.auth.session.user
                
                let currentProfile: Profile = try await supabase.database
                    .from("profiles")
                    .select()
                    .eq("uuid", value: currentUser.id)
                    .single()
                    .execute()
                    .value
                
                self.isAllowedToPost = currentProfile.isallowedtopost
                self.modifyAccountSettings = currentProfile.modifyaccountsettings
                self.allowedToInteractWithPosts = currentProfile.allowedtointeractwithposts
                self.allowedToPostMedia = currentProfile.allowedtopostmedia
                self.allowedToSendDM = currentProfile.allowedtosenddm
                self.allowedToViewProfiles = currentProfile.allowedtoviewprofiles
            } catch {
                
            }
        }
         .preferredColorScheme(colorScheme) 
    }
}
