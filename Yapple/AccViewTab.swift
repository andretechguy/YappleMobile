import SwiftUI

struct AccTabView: View {
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
    @State var Profiles: [Profile] = []
    @State var username = ""
    @State var displayName = ""
    @State var website = ""
    @State var bio = ""
    @State var isVerified = false
    @State var userPfp = ""
    @State var userBanner = ""
    @AppStorage("allowedToViewProfiles") var allowedToViewProfiles = true
    var body: some View {
        VStack(alignment: .center) {
            if !allowedToViewProfiles {
                Spacer()
                Image(systemName: "nosign")
                    .font(.system(size: 50, weight: .semibold))
                Text("You Are Unable To View Profiles Due To Restrictions")
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(Profiles) { profile in 
                        VStack(alignment: .leading, spacing: 10) {
                            
                            AsyncImage(url: URL(string: profile.bannerURL ?? "")) { phase in
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
                                AsyncImage(url: URL(string: profile.avatarURL ?? "")) { phase in
                                    switch phase {
                                    case .failure:
                                        Image(systemName: "exclamationmark.octagon.fill")
                                            .font(.largeTitle)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                        
                                    default:
                                        ZStack {
                                            ProgressView()
                                            Image("PFP")
                                                .resizable()
                                                .scaledToFill()
                                                .redacted(reason: .placeholder)
                                        }
                                        
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(profile.isapporg ? 10.0 : 50.0)
                                .padding(.leading, 20)
                                VStack(alignment: .leading, spacing: 1) {
                                    HStack(alignment: .center, spacing: 4) {
                                        Text(profile.name ?? "")
                                            .font(.headline)
                                        if profile.isVerified {
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(.blue)
                                        } else {
                                            
                                        }
                                        
                                    }
                                    Text("@\(profile.username)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            if ((profile.bio?.isEmpty) != nil){
                                Text(profile.bio ?? "")
                                    .padding(.horizontal, 20)
                                    .padding(.top, 5)
                            } else {
                               
                            }
                            if ((profile.website?.isEmpty) != nil){
                                Text(profile.website ?? "")
                                    .padding(.horizontal, 20)
                                    .padding(.top, 5)
                            } else {
                                
                            }
                            
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
                    }
                }
                .padding(.bottom, 75)
                .listStyle(.plain)
            }
             
        }
        .task {
            do {
                
                Profiles = try await supabase.database
                    .from("profiles")
                    .select()
                    .execute()
                    .value
            } catch {
                print(error)
            }
        }
         .preferredColorScheme(colorScheme) 
    }
    

}
