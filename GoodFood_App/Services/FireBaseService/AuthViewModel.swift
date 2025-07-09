//
//  AuthViewModel.swift
//  Good_Food
//
//  Created by Guest User on 30/6/25.
//
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var user: UserModel?
    @Published var showUserInfoForm = false

    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController
        else {
            print("Không tìm thấy rootVC")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("Lỗi đăng nhập Google: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("Không lấy được token")
                return
            }

            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print("Firebase login error: \(error.localizedDescription)")
                    return
                }

                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    let firebaseUser = Auth.auth().currentUser
                    self.user = UserModel(
                        id: firebaseUser?.uid ?? UUID().uuidString,
                        email: firebaseUser?.email ?? "",
                        displayName: firebaseUser?.displayName,
                        photoURL: firebaseUser?.photoURL?.absoluteString
                    )

                    self.checkIfUserHasInfo()
                }
            }
        }
    }

    private func checkIfUserHasInfo() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("User").document(userID).getDocument { document, _ in
            if let document = document, document.exists {
                let data = document.data()
                if let age = data?["age"] as? Int, age > 0 {
                    self.showUserInfoForm = false // Đã có info rồi
                } else {
                    self.showUserInfoForm = true // Chưa có info
                }
            } else {
                self.showUserInfoForm = true // Không có document -→ lần đầu
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.user = nil
        } catch {
            print("Lỗi đăng xuất: \(error.localizedDescription)")
        }
    }

    func checkIfLoggedIn() {
        let firebaseUser = Auth.auth().currentUser
        if let user = firebaseUser {
            self.isLoggedIn = true
            self.user = UserModel(
                id: user.uid,
                email: user.email ?? "",
                displayName: user.displayName,
                photoURL: user.photoURL?.absoluteString
            )
        } else {
            self.isLoggedIn = false
            self.user = nil
        }
    }
}
