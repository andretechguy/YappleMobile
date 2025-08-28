import SwiftUI
import Supabase

struct AuthView: View {
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
    @State var email = ""
    @State var password = ""
    @State var isLoading = false
    @State var result: Result<Void, Error>?
   @State var showingError = false
   @State var errorMessage = ""
    var body: some View {
        
        ZStack {
            
            VStack {
                
                VStack {
                    Image("icon")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(25)
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Sign in to Yapple to create and interact with posts")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                }
                .padding(.top)
                Form {
                    Section {
                        
                        
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        if let result {
                            Section {
                                switch result {
                                case .success:
                                    Text("Success")
                                    
                                case .failure(let error):
                                    var errorMessage = error.localizedDescription
                                    Text(errorMessage).foregroundStyle(.red)
                                }
                            }
                        }
                        
                    } 
                    
                    Section {
                        HStack (spacing: 5) {
                            Button("Sign in") {
                                signInButtonTapped()
                            }
                            
                            if isLoading {
                                ProgressView()
                            }
    
                        }
                    }
                    
                }
                .background(Color.black)
                
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            //vstack ends
        } 
    }
        
    func signInButtonTapped() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                try await supabase.auth.signIn(
                    email: email,
                    password: password
                )
                result = .success(())
            } catch {
                var errorMessage = error
                result = .failure(error)
            }
        }
    }
}

struct CustomTextField: View {
    @State var title: String
    @State var text = ""
    var body: some View {
        VStack {
            TextField(title, text: $text)
                .frame(height: 55)
        }
    }
}
