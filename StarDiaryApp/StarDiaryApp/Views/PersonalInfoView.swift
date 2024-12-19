//
//  PersonalInfoView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// 个人信息页面
// 用户可以在此页面查看和编辑自己的个人信息，包括修改密码和头像
struct PersonalInfoView: View {
    @EnvironmentObject var userViewModel: UserViewModel // 从环境中获取用户视图模型
    @State private var showingChangePassword = false   // 控制“修改密码”页面的显示状态
    @State private var editingInfo = false             // 是否处于编辑模式
    @State private var newEmail = ""                   // 编辑模式下的新邮箱
    @State private var newAvatarURLString = ""         // 编辑模式下的新头像URL

    var body: some View {
        NavigationView {
            Form {
                if let user = userViewModel.currentUser {
                    Section(header: Text("头像与邮箱")) {
                        HStack {
                            // 显示用户头像
                            AvatarView(avatarURL: user.avatarURL)
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                if editingInfo {
                                    // 编辑模式下的邮箱输入框
                                    TextField("邮箱", text: $newEmail)
                                        .textInputAutocapitalization(.none)
                                        .autocorrectionDisabled()
                                } else {
                                    // 非编辑模式下显示邮箱
                                    Text(user.email)
                                }
                            }
                        }

                        if editingInfo {
                            // 编辑模式下的头像URL输入框
                            TextField("头像URL", text: $newAvatarURLString)
                                .keyboardType(.URL)
                        } else if let url = user.avatarURL {
                            // 非编辑模式下显示头像URL
                            Text("头像URL：\(url.absoluteString)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }

                    Section {
                        // 修改密码按钮
                        Button("修改密码") {
                            showingChangePassword = true
                        }
                        // 退出登录按钮
                        Button("退出登录") {
                            userViewModel.logout() // 调用视图模型的退出方法
                        }
                        .foregroundColor(.red)
                    }
                } else {
                    // 如果用户未登录
                    Text("未登录")
                }
            }
            .navigationTitle("个人信息") // 设置导航栏标题
            .navigationBarItems(
                trailing: EditButtonInfo(editing: $editingInfo, newEmail: $newEmail, newAvatarURLString: $newAvatarURLString)
                    .environmentObject(userViewModel) // 确保子组件正确获取环境对象
            )
            .sheet(isPresented: $showingChangePassword) {
                ChangePasswordView()
                    .environmentObject(userViewModel) // 注入环境对象
            }
            .onAppear {
                // 页面加载时初始化编辑内容
                if let user = userViewModel.currentUser {
                    newEmail = user.email
                    newAvatarURLString = user.avatarURL?.absoluteString ?? ""
                }
            }
        }
    }
}

// 编辑按钮组件
struct EditButtonInfo: View {
    @Binding var editing: Bool                 // 是否处于编辑模式
    @Binding var newEmail: String             // 新邮箱
    @Binding var newAvatarURLString: String   // 新头像URL
    @EnvironmentObject var userViewModel: UserViewModel // 从环境中获取用户视图模型

    var body: some View {
        Button(editing ? "完成" : "编辑") {
            if editing {
                // 完成编辑时保存信息
                if !newEmail.isEmpty {
                    let url = URL(string: newAvatarURLString)
                    userViewModel.updateUserInfo(email: newEmail, avatarURL: url)
                }
            }
            editing.toggle() // 切换编辑状态
        }
    }
}

// 修改密码视图
struct ChangePasswordView: View {
    @EnvironmentObject var userViewModel: UserViewModel // 从环境中获取用户视图模型
    @Environment(\.presentationMode) var presentationMode // 用于关闭当前视图

    @State private var oldPassword = "" // 旧密码
    @State private var newPassword = "" // 新密码
    @State private var changeFailed = false // 是否修改失败

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("旧密码")) {
                    SecureField("输入旧密码", text: $oldPassword)
                }
                Section(header: Text("新密码")) {
                    SecureField("输入新密码", text: $newPassword)
                }
                if changeFailed {
                    // 显示错误提示
                    Text("修改失败，请检查旧密码或新密码输入").foregroundColor(.red)
                }
                Section {
                    // 确认修改密码按钮
                    Button("确认修改") {
                        let success = userViewModel.changePassword(oldPassword: oldPassword, newPassword: newPassword)
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            changeFailed = true
                        }
                    }
                    // 取消修改密码按钮
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("修改密码", displayMode: .inline)
        }
    }
}
