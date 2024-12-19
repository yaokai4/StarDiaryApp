//
//  Folder.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import Foundation // 基础库

// 文件夹模型
// 一个文件夹包含：唯一ID、名称、以及可选的父文件夹ID（为nil表示顶级文件夹）
// Identifiable:可在列表中直接使用
// Codable:便于数据持久化
// Hashable:便于在Picker或Set中使用
// 文件夹数据模型
struct Folder: Identifiable, Codable, Hashable {
    let id: UUID                  // 唯一标识符
    var name: String              // 文件夹名称
    var parentFolderID: UUID?     // 父文件夹的ID（如果是顶级文件夹，则为 nil）

    init(id: UUID = UUID(), name: String, parentFolderID: UUID? = nil) {
        self.id = id
        self.name = name
        self.parentFolderID = parentFolderID
    }
}
