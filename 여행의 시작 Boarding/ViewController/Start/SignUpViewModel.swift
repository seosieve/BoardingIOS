//
//  SignUpViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/15.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    func createUser(email: String, password: String, createUserHandler: @escaping (String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let errorString = error.localizedDescription
                createUserHandler(errorString)
            } else {
                createUserHandler(nil)
            }
        }
    }
}
