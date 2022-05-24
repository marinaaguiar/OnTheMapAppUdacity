
import Foundation

class UserAuthentication {
    struct Auth {
        static var registered: Bool = false
        static var sessionId = ""
    }

    enum ApiError: Error {
        case unknownError
    }

    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"

        case login
        case getUsersLocation

        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .getUsersLocation:
                return Endpoints.base + "/StudentLocation"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    static var session: URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "User-Agent": "dev.alecrim.test/1.0"
        ]

        return URLSession(configuration: sessionConfig)
    }

    class func post<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

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
                print(String(data: newData, encoding: .utf8)!)

                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async { [data, response, error] in
                    print(response!)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    class func get<ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()

        return task
    }


    class func login(
        username: String,
        password: String,
        completion: @escaping (Bool, Error?) -> Void) {

        let body = LoginRequest(username: username, password: password)
            post(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                print(response.account.registered)
                Auth.registered = response.account.registered
                completion(true, nil)
            } else {
                print(error?.localizedDescription)
                completion(false, error)
            }
        }
    }

    class func getStudentsLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        print(Endpoints.getUsersLocation.url)
        get(url: Endpoints.getUsersLocation.url, responseType: StudentResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                print(error.debugDescription)
                completion([], error)
            }
        }
    }

//    class func createNewStudentLocation(completion: @escaping () -> Void ) {
//        let post =
//    }
//
//    class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
//            DispatchQueue.main.async {
//                completion(data, error)
//            }
//        }
//        task.resume()
//    }



}


