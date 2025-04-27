//
//  AuthManager.swift
//  smallpdf
//
//  Created by 
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func gertRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func signIn(completion: @escaping () -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: gertRootViewController()) { result, error in
            if let error  = error {
                print("Google sign-in failed: \(error.localizedDescription)")
                return
            }
            guard let result = result else {
                print("No result returned from sign-in")
                return
            }
            //let email = result.user.profile?.email ?? "No email"
            completion()
        }
    }
    
    func signOut(completion: @escaping () -> Void){
        GIDSignIn.sharedInstance.signOut()
        completion()
    }
}
