//
//  UserProfileView.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//

import SwiftUI
import Foundation
import UIKit

//Profilemanger
class ProfileImageManager {
    static let shared = ProfileImageManager()
    private init() {}

    private let filename = "profile.jpg"

    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }

    func save(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }

    func load() -> UIImage? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

//    func delete() {
//        try? FileManager.default.removeItem(at: fileURL)
//    }
}


//Image picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}



struct UserProfileView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var selectedTab: Int
    //variables
           @State private var profileImage: UIImage? = nil
           @State private var showingImagePicker = false
           @State private var selectedImage: UIImage?
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea(edges: .top)
            ZStack {
                VStack {
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    //Text(mainViewModel.authUserData?.uid ?? "null")
                    
                    //Image(systemName: "person.fill").resizable()
                        //.frame(width: 210, height: 210)
                        //.font(.largeTitle)
                    //value of type 'some View' has no member 'resizable'
                    
                    Text((mainViewModel.databaseUser?.username ?? "No user logged in"))
                        .font(.largeTitle)
                        .padding()
                    if let image = profileImage {
                                                        Image(uiImage: image)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 150, height: 150)
                                                                .clipShape(Circle())
                                                                .shadow(radius: 4)
                                                        } else {
                                                            Circle()
                                                                .fill(Color.gray.opacity(0.3))
                                                                .frame(width: 150, height: 150)
                                                                .overlay(
                                                                    Image(systemName: "person.fill")
                                                                        .font(.system(size: 100))
                                                                )
                                                        }

                                                        Button("Change Picture") {
                                                            showingImagePicker = true
                                                        }
                                                        .padding()
                                                        .foregroundColor(.white)
                                                        .background(Color.black)
                                                        .cornerRadius(10)
                                                        .padding(.top, 20)
                                                        .padding(.bottom, 20)
                    Text("You are now signed in")
                        .padding()
                    
                    Button {
                        selectedTab = 0
                    } label: {
                        HStack {
                            Text("Get Started")
                            Image(systemName: "arrowshape.right.fill")
                        }
                    }
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .padding(.bottom, 150)
                    
                    Button {
                        mainViewModel.signOut()
                    } label: {
                        Text("Sign Out")
                            .padding(10)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(10)
                            .font(.title)
                    }
                    .offset(y: -100)
                }//vstack ends here
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                                if let selected = selectedImage {
                                    ProfileImageManager.shared.save(image: selected)
                                    profileImage = selected
                                }
                            }) {
                                ImagePicker(image: $selectedImage)

                            }
            }
        }
        .onAppear {
            mainViewModel.fetchCurrentUserEmail()
            mainViewModel.fetchUserData()
        }
    }
}

#Preview {
    UserProfileView(
        mainViewModel: MainViewModel(),
        selectedTab: .constant(1)
    )
}
