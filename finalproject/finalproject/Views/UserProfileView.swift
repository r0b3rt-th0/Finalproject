//
//  UserProfileView.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//

import SwiftUI
import Foundation
import UIKit

// MARK: - Profile Manager
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
}

// MARK: - Image Picker
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

// MARK: - User Profile View
struct UserProfileView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @Binding var selectedTab: Int

    @State private var profileImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 241/255, green: 234/255, blue: 220/255),
                    .black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)

            VStack {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()

                Text(mainViewModel.databaseUser?.username ?? "No user logged in")
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
                        .fill(Color.white)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.black)
                        )
                }

                Button("Change Picture") {
                    showingImagePicker = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(10)
                .padding(.vertical, 20)

                Text("You are now signed in")
                    .foregroundStyle(.white)
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
                .foregroundColor(.white)
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
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: {
                if let selected = selectedImage {
                    ProfileImageManager.shared.save(image: selected)
                    profileImage = selected
                }
            }) {
                ImagePicker(image: $selectedImage)
            }
        }
        .onAppear {
            mainViewModel.fetchCurrentUserEmail()
            mainViewModel.fetchUserData()
        }
    }
}

// MARK: - Preview
#Preview {
    UserProfileView(
        mainViewModel: MainViewModel(),
        selectedTab: .constant(1)
    )
}
