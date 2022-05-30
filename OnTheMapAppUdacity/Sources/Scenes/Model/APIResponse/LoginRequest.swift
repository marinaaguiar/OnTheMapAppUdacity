
import Foundation

struct LoginRequest: Codable {
    private struct LoginRequest: Codable {
        let username: String
        let password: String
    }

    private let udacity: LoginRequest

    init(username: String, password: String) {
        let request = LoginRequest(username: username, password: password)
        self.udacity = request
    }
}
