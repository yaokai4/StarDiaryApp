//
//  RegisterView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// RegisterView：用户注册界面
// 用户输入邮箱、密码、可选头像URL进行注册
struct RegisterView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    @State private var avatarURLString = ""
    @State private var registerFailed = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("邮箱")) {
                    TextField("输入邮箱", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.none)
                }
                
                Section(header: Text("密码")) {
                    SecureField("输入密码", text: $password)
                }
                
                Section(header: Text("头像URL（可选）")) {
                    TextField("输入头像URL", text: $avatarURLString)
                        .keyboardType(.URL)
                }
                
                if registerFailed {
                    Text("注册失败，请检查输入。").foregroundColor(.red)
                }
                
                Section {
                    Button("注册") {
                        // 尝试注册
                        let avatarURL = URL(string: avatarURLString)
                        let success = userViewModel.register(email: email, password: password, avatarURL: avatarURL)
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            registerFailed = true
                        }
                    }
                    
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("注册", displayMode: .inline)
        }
    }
}
