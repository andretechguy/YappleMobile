import SwiftUI

struct AccountView: View {
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
    @State var AccountPosts: [Post] = []
    @State var currentUserId = 0
    @State var currentName = ""
    @State var currentUserUsername = ""
    @State var currentUserPfp = ""
    @State var isVerified = false
    @AppStorage("allowedToPost") var isallowedtopost = true
    @AppStorage("allowedToModifySettings") var isallowedtomodifysettings = true
    @AppStorage("userIsInternal") var isinternaluser = false
    
    var body: some View {
            List {
                ProfileInfo()
                ForEach(AccountPosts.sorted(by: { $0.id > $1.id })) { post in
                    ZStack {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                AsyncImage(url: URL(string: currentUserPfp)) { phase in
                                    switch phase {
                                    case .failure:
                                        Image(systemName: "exclamationmark.octagon.fill")
                                            .font(.largeTitle)
                                    case .success(let image):
                                        image
                                            .resizable()
                                         .scaledToFill()
                                            
                                    default:
                                        ProgressView()
                                    }
                                }
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(50.0)
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack(alignment: .center, spacing: 4) {
                                        Text("\(currentName)")
                                            .font(.headline)
                                        if isVerified {
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(.blue)
                                        } else {
                                            
                                        }
                                        
                                    }
                                    Text("@\(currentUserUsername)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .hoverEffect(.lift)
                                Menu("\(Image(systemName: "ellipsis"))") {
                                    Button("Report Post", systemImage: "flag.fill") {
                                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                                    }
                                }
                                .hoverEffect(.lift)
                                .foregroundColor(.white)
                                .padding(.trailing, 7)
                                .padding(.leading, 5)
                            }
                            Text(post.content)
                            
                            if ((post.mediaURL?.isEmpty) != nil) {
                                AsyncImage(url: URL(string: post.mediaURL ?? "")) { phase in
                                    switch phase {
                                    case .failure:
                                        Image(systemName: "exclamationmark.octagon.fill")
                                            .font(.largeTitle)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    default:
                                        ProgressView()
                                    }
                                }
                                .cornerRadius(10)
                            } else {
                                
                            }
                            
                            
                            HStack {
                                Button(action: {}) {
                                    Image(systemName: "arrow.2.squarepath")
                                }
                                Button(action: {}) {
                                    Image(systemName: "message")
                                }
                                
                                Button(action: {}) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.top, 10)
                            .padding(.horizontal, 5)
                            .foregroundColor(.gray)
                        }
                        .padding(.vertical, 20)
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
                    
                    self.currentUserUsername = currentProfile.username
                    self.currentName = currentProfile.name ?? ""
                    self.currentUserPfp = currentProfile.avatarURL ?? ""
                    self.currentUserId = currentProfile.id
                    self.isVerified = currentProfile.isVerified
                    self.isallowedtopost = currentProfile.isallowedtopost
                    self.isallowedtomodifysettings = currentProfile.modifyaccountsettings
                    self.isinternaluser = currentProfile.isinternaluser
                } catch {
                    
                }
                do {
                    AccountPosts = try await supabase.database.from("posts").select().eq("postedBy", value: currentUserId).execute().value
                } catch {
                    
                    
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                
            }
            .preferredColorScheme(colorScheme) 
    }
    
}

struct ProfileInfo: View {
    @State var username = ""
    @State var displayName = ""
    @State var website = ""
    @State var bio = ""
    @State var currentUserId: Int = 0
    @State var isVerified = false
    @State var userPfp = ""
    @State var userBanner = ""
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                
                AsyncImage(url: URL(string: userBanner)) { phase in
                    switch phase {
                    case .failure:
                        Image(systemName: "exclamationmark.octagon.fill")
                            .font(.largeTitle)
                    case .success(let image):
                        image
                            .resizable()
                        
                            .scaledToFill()
                        
                    default:
                        Image("banner")
                            .resizable()
                            .scaledToFill()
                            .redacted(reason: .placeholder)
                    }
                }
                HStack {
                    AsyncImage(url: URL(string: userPfp)) { phase in
                        switch phase {
                        case .failure:
                            Image(systemName: "exclamationmark.octagon.fill")
                                .font(.largeTitle)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            
                        default:
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(50.0)
                        .padding(.leading, 20)
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(alignment: .center, spacing: 4) {
                            Text(displayName)
                                .font(.headline)
                            if isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                            } else {
                                
                            }
                            
                        }
                        Text("@\(username)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Text(bio)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                Text(website)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                HStack {
                    //should be changed to display the actual amount of followers later
                    Text("0 Following")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    Text("0 Followers")
                        .font(.headline)
                }
                .padding(.top, 5)
                .padding(.bottom, 15)
            }
            .task {
               await getInitialProfile()
            }
    }
    func getInitialProfile() async {
        do {
            let currentUser = try await supabase.auth.session.user
            
            let profile: Profile = try await supabase.database
                .from("profiles")
                .select()
                .eq("uuid", value: currentUser.id)
                .single()
                .execute()
                .value
            
            self.username = profile.username
            self.displayName = profile.name ?? ""
            self.website = profile.website ?? ""
            self.bio = profile.bio ?? ""
            self.currentUserId = profile.id
            self.isVerified = profile.isVerified
            self.userPfp = profile.avatarURL ?? ""
            self.userBanner = profile.bannerURL ?? ""
            
        } catch {
            debugPrint(error)
        }
    }
    
}
