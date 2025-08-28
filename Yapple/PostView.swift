import SwiftUI
import Supabase
import AVKit


struct PostView: View {
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
    
    @State var posts: [Post] = []
    @State private var showingNewPostSheet = false
    @AppStorage("allowedToPost") var isallowedtopost = true
    @AppStorage("allowedToInteract") var allowedToInteractWithPosts = true
    var body: some View {
        ZStack (alignment: .bottomTrailing) {
           List(posts.sorted(by: { $0.id > $1.id })) { post in
                ZStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("PFP")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(50.0)
                                .redacted(reason: .placeholder)
                            VStack(alignment: .leading, spacing: 5) {
                                HStack(alignment: .center, spacing: 4) {
                                    Text("\(post.postedBy)")
                                        .font(.headline)
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.blue)
                                }
                                Text("")
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
                            if !allowedToInteractWithPosts {
                                
                            } else {
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
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 5)
                        .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20)
                }
                  
            }
               .padding(.bottom, 75)
            .overlay {
                if posts.isEmpty {
                    VStack{
                        Image(systemName: "xmark.octagon.fill")
                            .font(.largeTitle)
                        Text("Something Went Wrong...")
                            .padding(10)
                    }
                }
            }
            .listStyle(PlainListStyle())
         
            .refreshable {
                do {
                    posts = try await supabase.database.from("posts").select().execute().value
                } catch {
                    dump(error)
                }
            }
            if isallowedtopost {
                //new post button
                Button {
                    showingNewPostSheet.toggle() 
                }label: {
                    Image(systemName: "plus")
                    //Add the following modifiers for a circular button.
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(BlurView())
                    
                        .cornerRadius(15)
                        .foregroundColor(colorScheme == .dark || colorScheme == .none ? Color.white : Color.black)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 15)
                                .stroke((colorScheme == .dark || colorScheme == .none ? Color.white : Color.black), lineWidth: 1)
                        )
                        .hoverEffect(.lift)
                        .padding(.bottom, 70)
                }
                //Apply padding to the button to position it correctly.
                //all button modifiers are located here
                .padding()
                .sheet(isPresented: $showingNewPostSheet) {
                    NavigationView {
                        NewPostView()
                    }
                } 
            } else {
                
            }
          
            
        }
      
        .task {
            do {
                posts = try await supabase.database.from("posts").select().execute().value
            } catch {
                dump(error)
            }
        }
        
    }
    
    private func getPosterName(_ number: Int) async -> String {
        var posterName: String? = ""
        do {
            posterName = try await supabase.database
                .from("profiles")
                .select("name")
                .eq("id", value: number)
                .execute()
                .value
        } catch {
            
        }
        return posterName ?? ""
    }    
}

struct NotesCell: View {
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.dashed")
                .font(.system(size: 60))
                .frame(width: 100, height: 100)
            Image("PFP")
                .resizable()
                .frame(width: 65, height: 65)
                .cornerRadius(50)
            
        }
    }
}

struct PostCell: View {
    @State var isLikedByCurrentUser = false
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image("PFP")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(50.0)
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .center, spacing: 4) {
                            Text("User")
                                .font(.headline)
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                        }
                        Text("")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Text("This is a sample post. This is a sample post. This is a sample post.")
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "message")
                    }
                    Button(action: {
                        isLikedByCurrentUser.toggle()
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.2.squarepath")
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .foregroundColor(.gray)
            }
            .padding(.vertical, 20)
        }
    }
}
