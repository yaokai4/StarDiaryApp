//
//  LoginView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// LoginView：用户登录界面
// 用户可输入邮箱、密码进行登录，也可点击注册新账号进入注册界面
struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegister = false
    @State private var loginFailed = false
    
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
                if loginFailed {
                    Text("登录失败，请检查邮箱或密码。").foregroundColor(.red)
                }
                Section {
                    Button("登录") {
                        // 尝试登录
                        if userViewModel.login(email: email, password: password) {
                            // 登录成功，上级视图会检测到currentUser不为空而切换界面
                        } else {
                            loginFailed = true
                        }
                    }
                    
                    Button("注册新账号") {
                        // 显示注册界面
                        showingRegister = true
                    }
                }
            }
            .navigationBarTitle("登录", displayMode: .inline)
            .sheet(isPresented: $showingRegister) {
                RegisterView()
                    .environmentObject(userViewModel)
            }
        }
    }
}
