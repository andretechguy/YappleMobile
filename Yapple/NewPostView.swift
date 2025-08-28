import SwiftUI
import Supabase

var postContent = ""
struct NewPostView: View {
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
    @Environment(\.dismiss) var dismiss
    @State var isLoading = false
    @State var result: Result<Void, Error>?
    @State var postContent = ""
    @State var currentUserId = 0
    @State var isallowedtopost = true
    @State var showingErrorAlert = false
    var body: some View {
        Form {
            Section {
                TextEditor( text: $postContent)
                
                if let result {
                    Section {
                        switch result {
                        case .success:
                            Text("Sent! You can now dismiss this sheet")
                        case .failure(let error):
                           var errorMessage = error.localizedDescription
                        }
                    }
                }
                
            }
            
            Section {
                HStack (spacing: 5) {
                    Button("Send") {
                        NewPostButtonPressed()
                    }
                    
                    if isLoading {
                        ProgressView()
                    }
                }
            }
            
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) { }
        }
        .task {
            Task {
                
                do {
                    let currentUser = try await supabase.auth.session.user
                    
                    let currentUserIdFetch: Profile = try await supabase.database
                        .from("profiles")
                        .select()
                        .eq("uuid", value: currentUser.id)
                        .single()
                        .execute()
                        .value
                    
                    self.currentUserId = currentUserIdFetch.id
                } catch {
                    
                } 
            }
        }
    }
    
    func NewPostButtonPressed() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                try await supabase.database
                    .from("posts")
                    .insert(NewPost(content: postContent, postedBy: currentUserId))
                    .execute() 
                print("button pressed")
                result = .success(())
            } catch {
                result = .failure(error)
                
            }
        }
    }
}
