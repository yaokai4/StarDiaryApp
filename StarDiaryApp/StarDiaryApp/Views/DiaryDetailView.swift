//
//  DiaryDetailView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// DiaryDetailView：查看日记的详细信息
// 包含标题、日期、分类、内容、图片附件
// 可点击右上角“编辑”进入编辑页面
struct DiaryDetailView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    let entry: DiaryEntry // 要查看的日记条目
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(entry.title)
                    .font(.largeTitle)
                    .bold()
                
                Text(formattedDate(entry.date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("分类：\(entry.category)")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Text(entry.content)
                    .font(.body)
                    .padding(.top, 5)
                
                if !entry.imageURLs.isEmpty {
                    Text("图片附件：")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(entry.imageURLs, id: \.self) { url in
                        if let data = try? Data(contentsOf: url),
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("日记详情")
        .navigationBarItems(
            trailing: NavigationLink("编辑") {
                // 点击编辑，进入编辑页面
                // 找到该日记所属文件夹对象
                let folder = diaryViewModel.folders.first { $0.id == entry.folderID }!
                DiaryEditView(folder: folder, entry: entry)
                    .environmentObject(diaryViewModel)
            }
        )
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
