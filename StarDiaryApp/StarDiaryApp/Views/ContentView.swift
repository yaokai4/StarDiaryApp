//
//  ContentView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// ContentView是主界面，根据用户是否登录显示不同内容
struct ContentView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    // 从环境中获取用户视图模型，以判断用户是否登录
    
    var body: some View {
        Group {
            if userViewModel.currentUser == nil {
                // 用户未登录，显示登录界面
                LoginView()
                    .environmentObject(userViewModel)
            } else {
                // 用户已登录，显示主Tab栏界面
                TabView {
                    // 主页Tab
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("主页")
                        }
                    
                    // 分类Tab：显示所有分类列表
                    CategoriesView()
                        .tabItem {
                            Image(systemName: "tag")
                            Text("分类")
                        }
                    
                    // 个人信息Tab：显示并可编辑用户信息
                    PersonalInfoView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("个人信息")
                        }
                }
            }
        }
    }
}
