//
//  MainViewModel.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//


//
//  MainViewModel.swift
//  FireFetch
//
//  Created by mikaila Akeredolu on 7/6/25.
// All the functionalities to use Firtebabse for Authentication and as a databse are here

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor
class MainViewModel: ObservableObject , Sendable {
    
@Published var showToast: Bool = false
@Published var toastMessage: String = ""
@Published var email = ""
@Published var username: String = ""
@Published var password: String = ""
@Published var isPasswordVisible: Bool = false
@Published var showSignInView: Bool = false
@Published var authUserData: UserData? = nil
@Published var isAuthenticated: Bool = false
@Published var databaseUser: DatabaseUser? = nil

init(){
    checkAuthenticationStatus()
    fetchCurrentUserEmail()
}

private func checkAuthenticationStatus() {

    DispatchQueue.main.async {
        
        if let user = Auth.auth().currentUser {
            
            self.isAuthenticated = true
            self.authUserData = UserData(user: user)
            
        }else{
            
            self.isAuthenticated = false
            self.authUserData = nil
            
        }
        
    }
    
}


func signOut() {

    do {

        try Auth.auth().signOut()
        
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.authUserData = nil
        }
        
    } catch {
        print("Error signing out: \(error)")
    }
    
}



//Handle Auth Error

private func handleAutherror(_ error: Error) {
    if let error = error as? NSError,
       let errorMessage = error.userInfo[NSLocalizedDescriptionKey] as? String {
            showToastMessage(errorMessage)
    }else{
            showToastMessage("An unknown error occured")
    }
}


private func showToastMessage(_ message: String) {
    
DispatchQueue.main.async {
        
    self.toastMessage = message
    self.showToast = true
        //async - setting a timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.showToast = false
        }
        
    }
}


func signIn()  {
    
    guard !email.isEmpty, !password.isEmpty else {
        print("Email or password are empty")
        return
    }
    
    Task{
        do {
            
            let result =  try await Auth.auth().signIn(withEmail: email, password: password)
            
            DispatchQueue.main.async {
                self.authUserData = UserData(user: result.user)
                self.isAuthenticated = true
            }
            
            print("Signed in successfully")
            
        } catch {
            DispatchQueue.main.async {
                self.handleAutherror(error)
            }
        }
        
    }
    
}

func signUp() {
    
    guard !email.isEmpty, !password.isEmpty else {
        print("Email or password are empty")
        return
    }
    
    Task{
        do {
            
            let result =  try await Auth.auth().createUser(withEmail: email, password: password)
            
            let userData = UserData(user: result.user)
                           
            let db = Firestore.firestore()
                               
            let databaseUser = DatabaseUser(userID: userData.uid, username: username, email: userData.email, dateCreated: Date())
                         
            try db.collection("users").document(userData.uid).setData(from: databaseUser, merge: false)
                               
            
            DispatchQueue.main.async {
                self.authUserData = UserData(user: result.user)
                self.isAuthenticated = true
            }
            
            print("Created user successfully")
            
        } catch {
            DispatchQueue.main.async {
                self.handleAutherror(error)
            }
        }
    }
    
}

    
func fetchCurrentUserEmail() {
       if let user = Auth.auth().currentUser {
           self.email = user.email ?? "Unknown Email"
       }
}

    
private func fetchDatabaseUser(withUID uid: String) async throws -> DatabaseUser {
  let db = Firestore.firestore()
  return try await db.collection("users").document(uid).getDocument(as: DatabaseUser.self)
}
      
    

func fetchUserData(){
  
  //get the uid
  guard let uid = Auth.auth().currentUser?.uid else {
      return
  }
  
  Task {
      do {
          let databaseUser = try await fetchDatabaseUser(withUID: uid)
          //open a dispatch que
          DispatchQueue.main.async {
              self.databaseUser = databaseUser //assign the db user found  by id to global state
              print("Fetched user data successfully: \(databaseUser)")
          }
      } catch {
          print("Error occured while fetching user data from db: \(error.localizedDescription)")
      }
  }
}
    

}


extension MainViewModel {
    func isValidEmail( ) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return !password.isEmpty && emailPredicate.evaluate(with: email)
    }
}
extension View {
    func tabBackgroundGradient() -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.red.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
