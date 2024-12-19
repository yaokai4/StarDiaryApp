//
//  AddEntryView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

struct AddEntryView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel // 确保注入了 DiaryViewModel
    @Environment(\.presentationMode) var presentationMode // 用于关闭视图

    @State private var title: String = ""      // 日记标题输入框的内容
    @State private var content: String = ""    // 日记内容输入框的内容
    @State private var category: String = "未分类" // 默认分类
    @State private var selectedFolder: Folder? // 用户选择的文件夹

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标题")) {
                    TextField("请输入标题", text: $title)
                }
                Section(header: Text("内容")) {
                    TextEditor(text: $content)
                        .frame(height: 150)
                }
                Section(header: Text("分类")) {
                    TextField("分类", text: $category)
                }
                Section(header: Text("选择文件夹")) {
                    Picker("文件夹", selection: $selectedFolder) {
                        ForEach(diaryViewModel.folders, id: \.id) { folder in
                            Text(folder.name).tag(folder as Folder?)
                        }
                    }
                }
            }
            .navigationBarTitle("添加日记", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss() // 关闭视图
                },
                trailing: Button("保存") {
                    guard let selectedFolder = selectedFolder else { return }
                    // 保存逻辑
                    diaryViewModel.addEntry(
                        title: title,
                        content: content,
                        category: category,
                        folder: selectedFolder,
                        images: []
                    )
                    presentationMode.wrappedValue.dismiss() // 成功后关闭视图
                }
            )
        }
    }
}
