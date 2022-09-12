import Foundation

struct PeerUserData: Codable {
    var name: String
    var inputMuted: Int?
    var outputMuted: Int?
    var platform: String?
    var version: String?
}
