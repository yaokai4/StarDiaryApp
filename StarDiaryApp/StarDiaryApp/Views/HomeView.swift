//
//  HomeView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/20.
//

import SwiftUI

// HomeView：应用主页
// 显示顶级文件夹的内容（包括子文件夹与日记）
// 不显示“根文件夹”字样，只显示内容本身
// 顶部有“添加”菜单，可添加文件夹或日记
// 使用自定义编辑按钮在左侧切换编辑模式
struct HomeView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @Environment(\.editMode) var editMode
    
    @State private var showingAddFolderAlert = false
    @State private var newFolderName = ""     // 新文件夹名输入状态
    @State private var showingDiaryEditView = false
    @State private var folderForNewDiary: Folder?
    
    var topFolder: Folder? {
        // 获取顶级文件夹（本例只有一个顶级文件夹"我的日记"）
        return diaryViewModel.topLevelFolders().first
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let folder = topFolder {
                    // 显示该顶级文件夹下的文件夹与日记混合列表
                    List {
                        // 子文件夹列表
                        let subFolders = diaryViewModel.subFolders(of: folder)
                        let folderItems = subFolders.map { FolderOrEntry.folder($0) }
                        
                        // 日记列表
                        let entries = diaryViewModel.entries(in: folder)
                        let entryItems = entries.map { FolderOrEntry.entry($0) }
                        
                        // 将文件夹和日记整合为同一列表
                        let allItems = folderItems + entryItems
                        
                        ForEach(allItems, id: \.id) { item in
                            switch item {
                            case .folder(let f):
                                // 点击进入文件夹详情页
                                NavigationLink(destination: FolderDetailView(folder: f)) {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text(f.name)
                                    }
                                }
                            case .entry(let e):
                                // 点击查看日记详情
                                NavigationLink(destination: DiaryDetailView(entry: e)) {
                                    VStack(alignment: .leading) {
                                        Text(e.title)
                                            .font(.headline)
                                        Text(formattedDate(e.date))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                } else {
                    // 如果没有顶级文件夹，则显示暂无内容
                    Text("暂无内容")
                }
            }
            .navigationBarTitle("主页", displayMode: .inline)
            .navigationBarItems(
                leading: EditButtonWrapper(), // 左侧编辑按钮
                trailing:
                    Menu("添加") {
                        Button("添加文件夹") {
                            showingAddFolderAlert = true
                        }
                        Button("添加日记") {
                            // 添加日记时需要指定文件夹，这里使用顶级文件夹
                            if let f = topFolder {
                                folderForNewDiary = f
                                showingDiaryEditView = true
                            }
                        }
                    }
            )
            .alert("新文件夹名称", isPresented: $showingAddFolderAlert) {
                // 弹框让用户输入新文件夹名
                TextField("请输入名称", text: $newFolderName)
                Button("取消", role: .cancel) {}
                Button("确定") {
                    // 确认添加文件夹
                    if let f = topFolder, !newFolderName.isEmpty {
                        diaryViewModel.addFolder(name: newFolderName, parent: f)
                    }
                    newFolderName = ""
                }
            }
            .sheet(isPresented: $showingDiaryEditView) {
                // 显示添加日记视图（DiaryEditView）
                if let folderForNewDiary = folderForNewDiary {
                    DiaryEditView(folder: folderForNewDiary, entry: nil)
                        .environmentObject(diaryViewModel)
                }
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        // 删除文件夹或日记条目
        if let folder = topFolder {
            let subFolders = diaryViewModel.subFolders(of: folder)
            let entries = diaryViewModel.entries(in: folder)
            let allItems = subFolders.map { FolderOrEntry.folder($0) } + entries.map { FolderOrEntry.entry($0) }
            
            for index in offsets {
                let item = allItems[index]
                switch item {
                case .folder(let f):
                    diaryViewModel.deleteFolder(f)
                case .entry(let e):
                    diaryViewModel.deleteEntry(e)
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        // 将日期格式化为中文显示
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    enum FolderOrEntry {
        // 枚举类型，用于统一表示文件夹或日记
        case folder(Folder)
        case entry(DiaryEntry)
        
        var id: UUID {
            // 返回对应的UUID，供ForEach使用
            switch self {
            case .folder(let f): return f.id
            case .entry(let e): return e.id
            }
        }
    }
}

// 自定义的编辑按钮组件，用中文“编辑”和“完成”
struct EditButtonWrapper: View {
    @Environment(\.editMode) var editMode
    var body: some View {
        Button(action: {
            withAnimation {
                // 切换列表编辑模式
                editMode?.wrappedValue = (editMode?.wrappedValue == .active) ? .inactive : .active
            }
        }) {
            Text(editMode?.wrappedValue == .active ? "完成" : "编辑")
        }
    }
}
