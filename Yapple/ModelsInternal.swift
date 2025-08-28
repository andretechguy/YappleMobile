import SwiftUI
import Foundation

struct ProfileInt: Decodable {
    let username: String?
    let name: String?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case name = "name"
        case website
    }
}

struct UpdateProfileParams: Encodable {
    let username: String
    let name: String
    let website: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case name = "name"
        case website
    }
}
