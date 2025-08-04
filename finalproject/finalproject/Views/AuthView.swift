//
//  AuthView.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var mainViewModel : MainViewModel
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 241/255, green: 234/255, blue: 220/255),
                    .black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
                    VStack(spacing: 16){
                        Image("Logo")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 250, height: 250)
                        Spacer()
                            .frame(height: 100)
                            .border(Color.black, width: 10)
                        
                        
                        //email reusable view
                        emailTextField
                        
                        //show username field when not in sign in view
                        if mainViewModel.showSignInView == false {
                            usernameTextField
                        }
                        
                        //password
                        passwordTextField
                        
                        //Action Button
                        actionButton
                        
                        //toggle Button
                        toggleButton
                    
                    }
                    .padding()
                    
                    
                    if mainViewModel.showToast {
                        ToastView(message: mainViewModel.toastMessage)
                            .padding(.top, 50)
                            .transition(.opacity)
                            .animation(
                                .easeIn(duration: 0.8),
                              value: mainViewModel.showToast
                            )
                    } // showTaost if statement
                    
                    
                } //end of zsack










    } //end of body
    
    
    //Reusabele Views go here
        
        //Email
        private var emailTextField: some View {
            HStack{
                TextField("Email", text: $mainViewModel.email)
                    .padding()
                    .foregroundStyle(.black)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }.background()
        } // end of reusable email view
        
        //Password
        private var passwordTextField: some View {
                
                HStack{
                    if mainViewModel.isPasswordVisible {
                        TextField("Password", text: $mainViewModel.password)
                            .padding()
                            .foregroundStyle(.black)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }else{
                        
                        SecureField("Password", text: $mainViewModel.password)
                            .padding()
                            .foregroundStyle(.black)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                  
                    //Eye button to toggle secure field
                    Button {
                        mainViewModel.isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: mainViewModel.isPasswordVisible ? "eye.slash" : "eye"
                        ).foregroundStyle(.black)
                        
                    }.padding(.trailing, 8)
                    
                }
                .background()
            
            
        } // end of reusable password view
        
        //UserName
        private var usernameTextField: some View {
            HStack{
                TextField("Username", text: $mainViewModel.username)
                    .padding()
                    .foregroundStyle(.black)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }.background()
        } // end of reusable username view
        
        
        //Sign in Or Sign UP Button
        private var actionButton: some View {
            Button {
      
                if mainViewModel.showSignInView{
                    mainViewModel.signIn()
                }else{
                    mainViewModel.signUp()
                }
            } label: {
        
                Text(mainViewModel.showSignInView ? "Sign In" : "Sign Up")
                    .font(.headline)
                    .foregroundColor(
                mainViewModel.isValidEmail() ? .white : .black
                    )
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        mainViewModel.isValidEmail() ? Color.green : Color.gray
                       // Color.green
                    )
                    .cornerRadius(10)

            }
            .disabled(!mainViewModel.isValidEmail())
        } //end of actionButton
        
        

        //Toggle view button to show Sign Up ir Sign In View
        private var toggleButton: some View {
            Button {
              
                mainViewModel.showSignInView.toggle()
              
            } label: {
                Text(
                mainViewModel.showSignInView ? "Don't have account? Sign Up"
                    : "Already have an account? Sign In"
                )
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                    mainViewModel.showSignInView ? Color.red : Color.black
                    )
                    .cornerRadius(10)

            }
        }
}

#Preview {
    AuthView(mainViewModel: MainViewModel())
}
