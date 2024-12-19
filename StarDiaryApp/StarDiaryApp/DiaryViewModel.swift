//
//  DiaryViewModel.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import Foundation

// 日记视图模型，用于管理文件夹和日记的数据
class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = [] // 所有日记条目
    @Published var folders: [Folder] = []    // 所有文件夹

    init() {
        createDefaultFolderIfNeeded() // 确保存在一个默认文件夹
    }

    // 确保默认顶级文件夹存在
    private func createDefaultFolderIfNeeded() {
        if folders.isEmpty {
            addFolder(name: "默认文件夹", parent: nil)
        }
    }

    // 返回所有顶级文件夹
    func topLevelFolders() -> [Folder] {
        return folders.filter { $0.parentFolderID == nil }
    }

    // 返回某文件夹下的子文件夹
    func subFolders(of folder: Folder) -> [Folder] {
        return folders.filter { $0.parentFolderID == folder.id }
    }

    // 返回某文件夹中的日记
    func entries(in folder: Folder) -> [DiaryEntry] {
        return entries.filter { $0.folderID == folder.id }
    }

    // 添加新文件夹
    func addFolder(name: String, parent: Folder?) {
        let newFolder = Folder(name: name, parentFolderID: parent?.id)
        folders.append(newFolder)
    }

    // 删除文件夹及其所有内容
    func deleteFolder(_ folder: Folder) {
        let children = subFolders(of: folder)
        for child in children {
            deleteFolder(child) // 递归删除子文件夹
        }
        entries.removeAll { $0.folderID == folder.id } // 删除该文件夹中的所有日记
        folders.removeAll { $0.id == folder.id }      // 删除该文件夹
    }

    // 添加新日记
    func addEntry(title: String, content: String, category: String, folder: Folder, images: [URL]) {
        let newEntry = DiaryEntry(title: title, content: content, category: category, folderID: folder.id, imageURLs: images)
        entries.append(newEntry)
    }

    // 更新日记
    func updateEntry(_ entry: DiaryEntry, title: String, content: String, category: String, images: [URL]) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].title = title
            entries[index].content = content
            entries[index].category = category
            entries[index].date = Date()
            entries[index].imageURLs = images
        }
    }

    // 删除日记
    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    // 移动日记到另一个文件夹
    func moveEntry(_ entry: DiaryEntry, to folder: Folder) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].folderID = folder.id
        }
    }
}
