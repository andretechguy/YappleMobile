import SwiftUI

struct TermsView : View {
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
      @ObservedObject var model: TextFileReaderModel = TextFileReaderModel(filename: "Terms")
    @AppStorage("userAgreedToTerms") var termsAccepted = false
   @State var animate = false
    var body: some View {
        VStack {
            Image(systemName: animate ? "info.circle.text.page" : "")
                .foregroundStyle(Color.white)
                .padding(.top)
                .font(.system(size: 50))
                .animation(.easeIn(duration: 1), value: animate)
                .onAppear { animate = true }
            Text("Terms & Conditions")
                .font(.title.weight(.medium))
                .padding(.top)
                .padding(.bottom, 0)
        }
        List {
            VStack(alignment: .leading, spacing: 20) {
                Text(model.data).frame(maxWidth: .infinity)
            }
            .padding()
        }
        .padding(0)
        HStack {
            Button {
                exit(0)
            }label: {
                Text("Decline")
                //Add the following modifiers for a circular button.
                    .font(.headline.weight(.semibold))
                    .padding(.vertical, 17)
                    .padding(.horizontal, 45)
                    .background(BlurView())
                    .cornerRadius(15)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 15)
                            .stroke((colorScheme == .dark ? Color.white : Color.black), lineWidth: 1)
                    )
                    .hoverEffect(.lift)
                    .padding(.bottom)
                    .padding(.horizontal, 10)
            }
            /* Button {
             
             } label: {
             Text("Decline")
             .font(.headline)
             .padding(.horizontal, 5)
             .padding(.vertical, 7)
             }
             .buttonStyle(.borderedProminent)
             .padding()
             .padding(.bottom, 10)
             .foregroundStyle(Color.gray)*/
            Button {
                print("accepted")
                termsAccepted = true
            }label: {
                Text("Accept")
                //Add the following modifiers for a circular button.
                    .font(.headline.weight(.semibold))
                    .padding(.vertical, 17)
                    .padding(.horizontal, 45)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .cornerRadius(15)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 15)
                            .stroke((colorScheme == .dark ? Color.white : Color.black), lineWidth: 1)
                    )
                    .hoverEffect(.lift)
                    .padding(.bottom)
                    .padding(.horizontal, 10)
                
            }
            /*   Button {
             
             } label: {
             Text("Accept")
             .font(.headline)
             .padding(.horizontal, 5)
             .padding(.vertical, 7)
             }
             .buttonStyle(.borderedProminent)
             .padding()
             .padding(.bottom, 10) */
        }
    }
}
