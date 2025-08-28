import SwiftUI
import Supabase

struct NewPost: Encodable {
    let content: String
    let postedBy: Int
}
struct NewPostOP: Encodable, Decodable {
    var postedBy: Int
}
struct Post: Identifiable, Decodable {
    var id: Int
    var postedBy: Int
    var content: String
    var mediaURL: String?
}

struct Profile: Decodable, Identifiable {
    let id: Int
    var username: String
    var avatarURL: String?
    var bio: String?
    var bannerURL: String?
    var name: String?
    var website: String?
    var isVerified: Bool
    var isallowedtopost: Bool
    var allowedtointeractwithposts: Bool
    var modifyaccountsettings: Bool
    var allowedtosenddm: Bool
    var allowedtopostmedia: Bool
    var allowedtoviewprofiles: Bool
     var isinternaluser: Bool
    var isapporg: Bool
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case avatarURL
        case bio
        case bannerURL
        case name = "name"
        case website
        case isVerified
        case isallowedtopost
        case allowedtointeractwithposts
        case modifyaccountsettings
        case allowedtosenddm
        case allowedtopostmedia
        case allowedtoviewprofiles
        case isinternaluser
        case isapporg
    }
}

struct updateProfile: Encodable, Identifiable {
    let id: Int
    let username: String
    let pfpURL: String
    let bio: String
    let bannerURL: String
    let name: String
}

struct Author: Decodable, Identifiable, Encodable {
    let id: Int
    let username: String
}

struct editPostContent: Encodable {
    let id: Int
    let content: String
}

struct Configurations: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
