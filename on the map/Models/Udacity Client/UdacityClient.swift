//
//  UdacityClient.swift
//  on the map
//
//  Created by Tunde Ola on 12/4/20.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        
        case login
        case udacitySignUp
        case getStudentLocation
        case createStudentLocation
        case getAUser(userId: String)
        case logout
        
        var stringValue: String {
            switch self {
                case .login:
                    return Endpoints.base + "/session"
                case .getStudentLocation:
                    return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
                case .udacitySignUp:
                    return "https://auth.udacity.com/sign-up"
                case .createStudentLocation:
                    return Endpoints.base + "/StudentLocation"
                case .logout:
                    return Endpoints.base + "/session"
                case .getAUser(let userId):
                    return Endpoints.base + "/users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: LoginCredentials(username: username, password: password))
        var request = URLRequest(url: UdacityClient.Endpoints.login.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print(String(data: data!, encoding: .utf8)!)
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try JSONDecoder().decode(SessionResponse.self, from: newData)
                print(responseObject)
                Auth.sessionId = responseObject.session.id
                Auth.userId = responseObject.account.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
        })
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: UdacityClient.Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                completion(false, error)
            }
              return
          }
            
            guard let data = data else { return}
            
          let range = 5..<data.count
          let newData = data.subdata(in: range)
            do {
                let responseObject = try JSONDecoder().decode(SessionLogoutResponse.self, from: newData)
                Auth.sessionId = ""
                Auth.userId = ""
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                print(responseObject)
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func createStudentLocation(body: LocationRequest, completion: @escaping (Bool, Error?) -> Void ) {
        var request = URLRequest(url: UdacityClient.Endpoints.createStudentLocation.url )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
             completion(false, error)
              return
          }
          completion(true, nil)
        }
        task.resume()
    }
    
    class func getSingleUser(completion: @escaping (StudentResponse?, Error?) -> Void) {
        let request = URLRequest(url: UdacityClient.Endpoints.getAUser(userId: Auth.userId).url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
            DispatchQueue.main.async {
                completion(nil, error)
                print("FROM GET SINGLE USER 1")
            }
          }
          guard let data = data else { return }
          let range = 5..<data.count
          let newData = data.subdata(in: range)
            do {
                let responseObject = try JSONDecoder().decode(StudentResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil )
                }
            } catch {
                DispatchQueue.main.async {
                    print("FROM GET SINGLE USER 2")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func getStudentsLocation(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: UdacityClient.Endpoints.getStudentLocation.url) { data, response, error in
            guard let data = data else {
                completion(nil,error)
                return
            }
            do {
                struct StudentsLocation: Codable {
                    let results: [StudentLocation]
                }
                let responseObject = try JSONDecoder().decode(StudentsLocation.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil )
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
}
