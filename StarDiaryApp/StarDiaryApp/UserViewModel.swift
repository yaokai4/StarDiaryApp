//
//  UserViewModel.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import Foundation

// UserViewModel：管理用户数据和用户操作的视图模型
class UserViewModel: ObservableObject {
    @Published var currentUser: User? // 当前登录的用户信息，若未登录则为 nil

    private let userKey = "CurrentUserKey" // 用于存储用户数据的本地键值

    init() {
        loadUser() // 初始化时加载用户数据
    }

    // MARK: - 用户注册

    /// 注册新用户
    /// - Parameters:
    ///   - email: 用户的邮箱地址
    ///   - password: 用户的密码
    ///   - avatarURL: 用户头像的 URL（可选）
    /// - Returns: 注册是否成功
    func register(email: String, password: String, avatarURL: URL?) -> Bool {
        guard !email.isEmpty, !password.isEmpty else { return false } // 检查邮箱和密码是否为空
        let newUser = User(email: email, password: password, avatarURL: avatarURL)
        currentUser = newUser // 将新用户设置为当前用户
        saveUser() // 保存用户数据到本地
        return true
    }

    // MARK: - 用户登录

    /// 用户登录
    /// - Parameters:
    ///   - email: 登录邮箱地址
    ///   - password: 登录密码
    /// - Returns: 登录是否成功
    func login(email: String, password: String) -> Bool {
        guard let user = currentUser else { return false } // 确保有用户数据可供验证
        return user.email == email && user.password == password // 校验邮箱和密码是否匹配
    }

    // MARK: - 用户注销

    /// 用户退出登录
    func logout() {
        currentUser = nil // 清空当前用户数据
        saveUser() // 更新本地存储
    }

    // MARK: - 更新用户信息

    /// 更新用户信息
    /// - Parameters:
    ///   - email: 新的邮箱地址
    ///   - avatarURL: 新的头像 URL
    func updateUserInfo(email: String, avatarURL: URL?) {
        guard var user = currentUser else { return } // 确保当前有登录的用户
        user.email = email // 更新邮箱地址
        user.avatarURL = avatarURL // 更新头像 URL
        currentUser = user // 保存更新后的用户信息
        saveUser() // 将数据同步到本地
    }

    // MARK: - 修改用户密码

    /// 修改用户密码
    /// - Parameters:
    ///   - oldPassword: 当前的旧密码
    ///   - newPassword: 用户设置的新密码
    /// - Returns: 修改是否成功
    func changePassword(oldPassword: String, newPassword: String) -> Bool {
        guard var user = currentUser, user.password == oldPassword else { return false } // 验证旧密码是否正确
        user.password = newPassword // 更新为新密码
        currentUser = user // 保存更新后的用户信息
        saveUser() // 同步到本地存储
        return true
    }

    // MARK: - 本地存储与加载

    /// 从本地加载用户数据
    private func loadUser() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: userKey), // 从本地读取数据
           let user = try? JSONDecoder().decode(User.self, from: data) { // 解码数据为 User 对象
            self.currentUser = user // 加载成功后赋值给 currentUser
        }
    }

    /// 保存用户数据到本地
    private func saveUser() {
        let defaults = UserDefaults.standard
        if let user = currentUser, // 确保当前有用户信息
           let data = try? JSONEncoder().encode(user) { // 将 User 对象编码为数据
            defaults.set(data, forKey: userKey) // 存储到 UserDefaults
        } else {
            defaults.removeObject(forKey: userKey) // 如果没有用户信息，则移除存储
        }
    }
}
