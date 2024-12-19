//
//  FolderView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// FolderDetailView：文件夹详情页面
// 该页面显示文件夹内的内容（子文件夹和日记），提供添加、删除和移动功能
struct FolderDetailView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel // 从环境中获取日记视图模型
    @Environment(\.presentationMode) var presentationMode // 用于控制页面返回

    let folder: Folder // 当前文件夹
    @State private var showingDiaryEditView = false // 控制是否显示日记编辑页面
    @State private var diaryToEdit: DiaryEntry? = nil // 当前需要编辑的日记，nil 表示添加模式

    @State private var selectedFolderForMove: Folder? = nil // 移动目标文件夹
    @State private var showingMoveDialog = false // 是否显示移动操作的弹框

    var body: some View {
        List {
            // 文件夹部分
            Section(header: Text("文件夹")) {
                ForEach(diaryViewModel.subFolders(of: folder), id: \.id) { subFolder in
                    NavigationLink(destination: FolderDetailView(folder: subFolder)) {
                        HStack {
                            Image(systemName: "folder")
                            Text(subFolder.name)
                        }
                    }
                }
                .onDelete(perform: deleteFolder) // 支持删除子文件夹
            }

            // 日记部分
            Section(header: Text("日记")) {
                ForEach(diaryViewModel.entries(in: folder), id: \.id) { entry in
                    NavigationLink(destination: DiaryDetailView(entry: entry)) {
                        VStack(alignment: .leading) {
                            Text(entry.title).font(.headline)
                            Text(formatDate(entry.date))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        // 长按菜单：提供移动和删除选项
                        Button("移动日记") {
                            diaryToEdit = entry
                            showingMoveDialog = true
                        }
                        Button("删除日记", role: .destructive) {
                            diaryViewModel.deleteEntry(entry)
                        }
                    }
                }
                .onDelete(perform: deleteEntry) // 支持滑动删除日记
            }
        }
        .navigationBarTitle(folder.name, displayMode: .inline) // 设置导航栏标题
        .navigationBarItems(
            trailing:
                Menu("添加") {
                    Button("添加日记") {
                        diaryToEdit = nil // 添加模式
                        showingDiaryEditView = true
                    }
                    Button("添加文件夹") {
                        addFolder()
                    }
                }
        )
        .sheet(isPresented: $showingDiaryEditView) {
            // 显示日记添加或编辑页面
            if let diaryToEdit = diaryToEdit {
                DiaryEditView(folder: folder, entry: diaryToEdit)
                    .environmentObject(diaryViewModel)
            } else {
                DiaryEditView(folder: folder, entry: nil)
                    .environmentObject(diaryViewModel)
            }
        }
        .alert("移动到文件夹", isPresented: $showingMoveDialog) {
            // 移动操作的弹框
            Picker("选择目标文件夹", selection: $selectedFolderForMove) {
                ForEach(diaryViewModel.folders, id: \.id) { folder in
                    Text(folder.name).tag(folder as Folder?)
                }
            }
            Button("取消", role: .cancel) {}
            Button("确定") {
                moveDiary()
            }
        }
    }

    // 添加新子文件夹
    private func addFolder() {
        let newFolderName = "新建文件夹 \(Int.random(in: 1...1000))"
        diaryViewModel.addFolder(name: newFolderName, parent: folder)
    }

    // 删除子文件夹
    private func deleteFolder(at offsets: IndexSet) {
        let subFolders = diaryViewModel.subFolders(of: folder)
        offsets.forEach { index in
            let folderToDelete = subFolders[index]
            diaryViewModel.deleteFolder(folderToDelete)
        }
    }

    // 删除日记条目
    private func deleteEntry(at offsets: IndexSet) {
        let entries = diaryViewModel.entries(in: folder)
        offsets.forEach { index in
            let entryToDelete = entries[index]
            diaryViewModel.deleteEntry(entryToDelete)
        }
    }

    // 移动日记条目
    private func moveDiary() {
        guard let diaryToEdit = diaryToEdit, let targetFolder = selectedFolderForMove else { return }
        diaryViewModel.moveEntry(diaryToEdit, to: targetFolder)
        showingMoveDialog = false
    }

    // 格式化日期
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
