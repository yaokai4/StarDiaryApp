//
//  DiaryEntry.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import Foundation

// 日记条目数据模型
struct DiaryEntry: Identifiable, Codable {
    let id: UUID                // 唯一标识符
    var title: String           // 日记标题
    var content: String         // 日记内容
    var date: Date              // 日记创建或最后修改日期
    var category: String        // 日记分类
    var folderID: UUID          // 所属文件夹的ID
    var imageURLs: [URL]        // 日记中的图片URL列表

    init(id: UUID = UUID(),
         title: String,
         content: String,
         category: String = "未分类",
         folderID: UUID,
         date: Date = Date(),
         imageURLs: [URL] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
        self.category = category
        self.folderID = folderID
        self.imageURLs = imageURLs
    }
}
