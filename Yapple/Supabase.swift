import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://PROJECTID.supabase.co")!,
    supabaseKey: "YOURSUPABSEKEY")

struct Posts: Decodable, Identifiable {
    let id: Int
    let createdAt: String
    let content: String
}
