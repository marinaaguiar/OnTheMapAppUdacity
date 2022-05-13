
import Foundation

class UserAuthentication {

    struct Auth {
        static var sessionId = ""
    }

    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"


        case login
        case createSessionId

        var stringValue: String {
            switch self {
            case .createSessionId:
                return Endpoints.base + "/session"
            case .login:
                return Endpoints.base
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }


    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                    print(responseObject)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }


    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.id
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
}


