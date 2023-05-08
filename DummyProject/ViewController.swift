//
//  ViewController.swift
//  BaseProject
//
//

import UIKit

class ViewController: UIViewController {
       
    override func viewDidLoad() {
        super.viewDidLoad()
        UserManager(service: DatabaseUserService()).fetchUser(username: "", password: "")
       
    }
  
}

// MARK: - EXAMPLE OF LISKOV SUBSTITUTION PRINCIPLE

struct User {
    let name: String
    let username: String
}

protocol UserService {
    func fetchUser(username: String, password: String, completion: @escaping(_ user: User?, _ error: Error?) -> Void)
}

class ApiUserService: UserService {
    func fetchUser(username: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        PrintToConsole("User fetched from Api")
        completion(User(name: "vikas saini", username: "vikasjhd"), nil)
    }
 
}

class DatabaseUserService: UserService {
    func fetchUser(username: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        PrintToConsole("User fetched from Database")
        completion(User(name: "vikas saini", username: "vikasjhd"), nil)
    }
}

class UserManager {
    
    var service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func fetchUser(username: String, password: String) {
        service.fetchUser(username: username, password: password) { _, _ in
           // handle here
        }
    }
}
