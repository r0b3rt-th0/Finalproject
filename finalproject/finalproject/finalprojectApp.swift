//
//  finalprojectApp.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct finalprojectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = MainViewModel()
    @State private var rootViewID = UUID()
    
    @State private var appData = ApplicationData.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            NavigationStack {
                currentView()
            }.environment(appData)
              .id(rootViewID) //resets the view heirarchy
                .onReceive(viewModel.$isAuthenticated) { isAuthenticated in
                    if !isAuthenticated {
                        print("user is signed out and now resetting view heirarchy")
                        rootViewID = UUID() //forces the nav stack to reset itself with new id
                    }
                    
                } //end of onReceived
        } //end of WindowGroup
        
    } //end of body
    @ViewBuilder
    private func currentView() -> some View {
        if viewModel.isAuthenticated {
            //UserProfileView(mainViewModel: viewModel)
            ContentView(mainViewModel: viewModel)
        } else {
            AuthView(mainViewModel: viewModel)
        }
    }
}
