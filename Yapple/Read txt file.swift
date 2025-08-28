import SwiftUI

class TextFileReaderModel: ObservableObject {
    @Published public var data: LocalizedStringKey = ""
    
    init(filename: String) { self.load(file: filename) }
    
    func load(file: String) {
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                DispatchQueue.main.async {
                    self.data = LocalizedStringKey(contents)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}
