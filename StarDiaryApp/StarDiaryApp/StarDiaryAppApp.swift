//
//  StarDiaryAppApp.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// 应用的入口点
@main
struct StarDiaryApp: App {
    // 全局的用户视图模型，用于管理用户信息
    @StateObject private var userViewModel = UserViewModel()
    // 全局的日记视图模型，用于管理文件夹和日记数据
    @StateObject private var diaryViewModel = DiaryViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel) // 将用户视图模型注入到视图环境中
                .environmentObject(diaryViewModel) // 将日记视图模型注入到视图环境中
        }
    }
}

