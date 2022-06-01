
import Foundation

class UserAuthentication {

    struct Auth {
        static var registered: Bool = false
        static var sessionId = ""
        static var objectId = ""
        static var createdAt = ""
        static var updatedAt = ""
        static var currentDate = ""
        static var firstName = ""
        static var lastName = ""
        static var uniqueKey = ""
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }

    static var itemsCounts = 15

    enum ApiError: Error {
        case unknownError
    }

    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"

        case session
        case getUsersLocation
        case getUsersLocationList
        case getUserData
        case postNewStudentLocation
        case putExistingStudentLocation

        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .getUsersLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .getUsersLocationList:
                return Endpoints.base + "/StudentLocation?limit=\(itemsCounts)&order=-updatedAt"
            case .getUserData:
                return Endpoints.base + "/users/\(Auth.sessionId)"
            case .postNewStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .putExistingStudentLocation:
                return Endpoints.base + "/StudentLocation/\(Auth.objectId)"
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
            let parsed: Result<ResponseType, Error> = parse(data: data)

            DispatchQueue.main.async {
                switch parsed {
                case let .success(object):
                    completion(object, nil)
                case let .failure(error):
                    print("🔴 ERROR: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }

    class func delete<ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()

            let parsed: Result<ResponseType, Error> = parse(data: data)

            DispatchQueue.main.async {
                switch parsed {
                case let .success(object):
                    completion(object, nil)
                case let .failure(error):
                    print("🔴 ERROR: \(error.localizedDescription)")
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

                let parsed: Result<ResponseType, Error> = parse(data: data)

                DispatchQueue.main.async {
                    switch parsed {
                    case let .success(object):
                        completion(object, nil)
                    case let .failure(error):
                        print("🔴 ERROR: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
            task.resume()

            return task
        }

    class func put<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let parsed: Result<ResponseType, Error> = parse(data: data)

            DispatchQueue.main.async {
                switch parsed {
                case let .success(object):
                    completion(object, nil)
                case let .failure(error):
                    print("🔴 ERROR: \(error)")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    private class func parse<C: Decodable>(data: Data) -> Result<C, Error> {
        let decoder = JSONDecoder()

        do {
            // First, try to decode the object as a standard JSON object.
            let standardDecoded = try decoder.decode(C.self, from: data)
            return .success(standardDecoded)
        } catch {
            do {
                // If it fails, try to fix the result.
                let range = 5..<data.count
                let fixupData = data.subdata(in: range)
                let fixupDecoded = try decoder.decode(C.self, from: fixupData)
                return .success(fixupDecoded)
            } catch {
                // If the fixup fails, return the error.
                return .failure(error)
            }
        }
    }

    class func login(
        username: String,
        password: String,
        completion: @escaping (Bool, Error?) -> Void) {

        let body = LoginRequest(username: username, password: password)
            post(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.registered = response.account.registered
                Auth.sessionId = response.account.key
                print("🔵THIS IS THE SESSION ID >> \(Auth.sessionId)")
                completion(true, nil)
            } else {
                debugPrint("🔴\(error?.localizedDescription)")
                completion(false, error)
            }
        }
    }

    class func logout(completion: @escaping (Bool, Error?) -> Void) {

        delete(url: Endpoints.session.url, responseType: LogoutResponse.self) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                print("🔵 SESSION FINISHED")
                completion(true, nil)
            } else {
                debugPrint("🔴\(error.debugDescription)")
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
                debugPrint("🔴\(error.debugDescription)")
                completion([], error)
            }
        }
    }

    class func getStudentsLocationList(itemsCount: Int, completion: @escaping ([StudentLocation], Error?) -> Void) {
        print(Endpoints.getUsersLocation.url)
        get(url: Endpoints.getUsersLocationList.url, responseType: StudentResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                print("🔴 ERROR: \(error?.localizedDescription)")
                completion([], error)
            }
        }
    }

    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        print("URL >>> \(Endpoints.getUserData.url)")
        get(url: Endpoints.getUserData.url, responseType: User.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                debugPrint("🔴 ERROR IS HERE >> \(error.debugDescription)")
                completion(false, error)
            }
        }
    }

    class func postNewStudentLocation(latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        print("URL >>> \(Endpoints.postNewStudentLocation.url)")

        let body = StudentModel(uniqueKey: Auth.uniqueKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: Auth.mapString, mediaURL: Auth.mediaURL, latitude: latitude, longitude: longitude)

        post(url: Endpoints.postNewStudentLocation.url, responseType: PostNewStudentLocationResponse.self, body: body, completion: { response, error in
            if let response = response {
                Auth.createdAt = response.createdAt
                Auth.objectId = response.objectId
                Auth.latitude = latitude
                Auth.longitude = longitude
                print("🔵THIS IS THE SESSION ID >> \(Auth.sessionId)")
                completion(true, nil)
            } else {
//                debugPrint("🔴\(error.debugDescription)")
                completion(false, error)
            }
        })
    }

    class func putExistingStudentLocation(latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        print("URL PUT>>> \(Endpoints.putExistingStudentLocation.url)")

        let body = StudentModel(uniqueKey: Auth.uniqueKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: Auth.mapString, mediaURL: Auth.mediaURL, latitude: latitude, longitude: longitude)
        put(url: Endpoints.putExistingStudentLocation.url, responseType: PutStudentLocationResponse.self, body: body, completion: { response, error in
            if let response = response {
                Auth.updatedAt = response.updateAt
                Auth.latitude = latitude
                Auth.longitude = longitude
                completion(true, nil)
                print("🟢 PUT RESPONSE \(response)")
            } else {
                completion(false, error)
                debugPrint("🔴 ERROR PUT IS HERE >> \(error.debugDescription)")
            }
        })
    }
}
