
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
    static var networkService = NetworkService()

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

    class func login(
        username: String,
        password: String,
        completion: @escaping (Bool, Error?) -> Void) {

        let body = LoginRequest(username: username, password: password)
            networkService.post(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.registered = response.account.registered
                Auth.sessionId = response.account.key
                debugPrint("🔵 This is session ID: \(Auth.sessionId)")
                completion(true, nil)
            } else {
                debugPrint("🔴 Error Login: \(error?.localizedDescription)")
                completion(false, error)
            }
        }
    }

    class func logout(completion: @escaping (Bool, Error?) -> Void) {

        networkService.delete(url: Endpoints.session.url, responseType: LogoutResponse.self) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                debugPrint("🔵 Session finished")
                completion(true, nil)
            } else {
                debugPrint("🔴 Error Logout: \(error.debugDescription)")
                completion(false, error)
            }
        }
    }

    class func getStudentsLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        debugPrint(Endpoints.getUsersLocation.url)
        networkService.get(url: Endpoints.getUsersLocation.url, responseType: StudentResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                debugPrint("🔴 Error GetStudentsLocation:\(error.debugDescription)")
                completion([], error)
            }
        }
    }

    class func getStudentsLocationList(itemsCount: Int, completion: @escaping ([StudentLocation], Error?) -> Void) {
        debugPrint(Endpoints.getUsersLocation.url)
        networkService.get(url: Endpoints.getUsersLocationList.url, responseType: StudentResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                debugPrint("🔴 Error GetStudentsLocationList: \(error?.localizedDescription)")
                completion([], error)
            }
        }
    }

    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        debugPrint("URL >>> \(Endpoints.getUserData.url)")
        networkService.get(url: Endpoints.getUserData.url, responseType: User.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                debugPrint("🔴 Error GetUserData: \(error.debugDescription)")
                completion(false, error)
            }
        }
    }

    class func postNewStudentLocation(latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        debugPrint("Url Post: \(Endpoints.postNewStudentLocation.url)")

        let body = StudentModel(uniqueKey: Auth.uniqueKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: Auth.mapString, mediaURL: Auth.mediaURL, latitude: latitude, longitude: longitude)

        networkService.post(url: Endpoints.postNewStudentLocation.url, responseType: PostNewStudentLocationResponse.self, body: body, completion: { response, error in
            if let response = response {
                Auth.createdAt = response.createdAt
                Auth.objectId = response.objectId
                Auth.latitude = latitude
                Auth.longitude = longitude
                debugPrint("🔵 This is session ID: \(Auth.sessionId)")
                completion(true, nil)
            } else {
                debugPrint("🔴 Error PostNewStudentLocation: \(error.debugDescription)")
                completion(false, error)
            }
        })
    }

    class func putExistingStudentLocation(latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        debugPrint("Url Put: \(Endpoints.putExistingStudentLocation.url)")

        let body = StudentModel(uniqueKey: Auth.uniqueKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: Auth.mapString, mediaURL: Auth.mediaURL, latitude: latitude, longitude: longitude)
        networkService.put(url: Endpoints.putExistingStudentLocation.url, responseType: PutStudentLocationResponse.self, body: body, completion: { response, error in
            if let response = response {
                Auth.updatedAt = response.updateAt
                Auth.latitude = latitude
                Auth.longitude = longitude
                completion(true, nil)
                debugPrint("🟢 Put Response: \(response)")
            } else {
                completion(false, error)
                debugPrint("🔴 Error Put: >> \(error.debugDescription)")
            }
        })
    }
}
