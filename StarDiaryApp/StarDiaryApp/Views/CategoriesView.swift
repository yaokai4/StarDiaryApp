//
//  CategoriesView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// CategoriesView：分类页面
// 显示所有日记的分类列表，并支持点击分类查看该分类下的所有日记
struct CategoriesView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel // 从环境中获取日记视图模型

    var body: some View {
        NavigationView {
            List {
                // 遍历所有分类，显示为列表
                ForEach(diaryViewModel.allCategories(), id: \.self) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        Text(category) // 显示分类名称
                    }
                }
            }
            .navigationTitle("分类") // 设置页面标题
        }
    }
}

// CategoryDetailView：分类详情页面
// 显示指定分类下的所有日记
struct CategoryDetailView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel // 从环境中获取日记视图模型
    let category: String // 当前分类名称

    var body: some View {
        List {
            // 遍历分类下的所有日记
            ForEach(diaryViewModel.entries(for: category), id: \.id) { entry in
                NavigationLink(destination: DiaryDetailView(entry: entry)) {
                    VStack(alignment: .leading) {
                        Text(entry.title).font(.headline) // 显示日记标题
                        Text(formatDate(entry.date)) // 显示日记日期
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(category) // 设置页面标题为分类名称
    }

    // 将日期格式化为易读的字符串
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
