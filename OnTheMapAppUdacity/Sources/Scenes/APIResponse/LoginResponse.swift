
import Foundation

struct LoginResponse: Codable {
    struct AccountResponse: Codable {
        let registered: Bool
        let key: String
    }

    struct SessionResponse: Codable {
        let id: String
        let expiration: String
    }

    let account: AccountResponse
    let session: SessionResponse
}
