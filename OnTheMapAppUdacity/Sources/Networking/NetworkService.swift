//
//  NetworkService.swift
//  OnTheMapAppUdacity
//
//  Created by Marina Aguiar on 6/2/22.
//

import Foundation

class NetworkService {

    var session: URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "User-Agent": "dev.alecrim.test/1.0"
        ]

        return URLSession(configuration: sessionConfig)
    }


    func get<ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {

            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }

                let parsed: Result<ResponseType, Error> = self.parse(data: data)

                DispatchQueue.main.async {
                    switch parsed {
                    case let .success(object):
                        completion(object, nil)
                    case let .failure(error):
                        debugPrint("🔴 Error Get: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            }
            task.resume()

            return task
        }

    func post<RequestType: Encodable, ResponseType: Decodable>(
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
            let parsed: Result<ResponseType, Error> = self.parse(data: data)

            DispatchQueue.main.async {
                switch parsed {
                case let .success(object):
                    completion(object, nil)
                case let .failure(error):
                    debugPrint("🔴 Error Post: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }

    func put<RequestType: Encodable, ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        body: RequestType,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let parsed: Result<ResponseType, Error> = self.parse(data: data)

            DispatchQueue.main.async {
                switch parsed {
                case let .success(object):
                    completion(object, nil)
                case let .failure(error):
                    debugPrint("🔴 Error Put: \(error)")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }


    func delete<ResponseType: Decodable>(
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
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            let parsed: Result<ResponseType, Error> = self.parse(data: data)

            DispatchQueue.main.async {
                switch parsed {
                case let .success(object):
                    completion(object, nil)
                case let .failure(error):
                    debugPrint("🔴 Error Delete: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }

    private func parse<C: Decodable>(data: Data) -> Result<C, Error> {
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
}
