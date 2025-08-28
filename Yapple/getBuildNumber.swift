import Foundation

struct BuildNumberStruct: Codable {
    let ProductBuildVersion: String
}


var BuildNumber: BuildNumberStruct?

func readPlist() {
    
    let fileURL = URL(fileURLWithPath: "/System/Library/CoreServices/SystemVersion.plist")
    
    do {
        let data = try Data(contentsOf: fileURL)
        BuildNumber = try PropertyListDecoder().decode(BuildNumberStruct.self, from: data)
       
        
        print("Decoded Config: \(BuildNumber?.ProductBuildVersion ?? "")")
    } catch {
        print("Failed to decode plist: \(error)")
    }
}

