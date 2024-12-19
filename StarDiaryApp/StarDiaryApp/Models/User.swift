//
//  User.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import Foundation

// 定义用户数据模型
struct User: Codable {
    var email: String    // 用户邮箱
    var password: String // 用户密码
    var avatarURL: URL?  // 用户头像的URL（可选）
}
