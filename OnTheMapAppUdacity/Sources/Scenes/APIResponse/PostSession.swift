
import Foundation

struct AccountResponse: Codable {
    let registered: Bool
    let key: String
}

struct SessionResponse: Codable {
    let id: String
    let expiration: String
}
