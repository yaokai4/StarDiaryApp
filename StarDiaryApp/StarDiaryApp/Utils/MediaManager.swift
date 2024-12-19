//
//  MediaManager.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import Foundation
import UIKit

// MediaManager：简单的媒体存储管理类
// 用于将从PhotosPicker获得的Data保存到本地Documents目录并返回URL
// 实际生产环境中可能需要更多的错误处理和异步加载机制
class MediaManager {
    static let shared = MediaManager()
    private init() {}
    
    func saveMedia(data: Data, fileExtension: String) throws -> URL {
        // 生成唯一文件名，以UUID命名，确保不会重复
        let fileName = UUID().uuidString + "." + fileExtension
        // 获取应用的Documents目录
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // 构造目标文件URL
        let fileURL = documentsURL.appendingPathComponent(fileName)
        // 将数据写入文件
        try data.write(to: fileURL)
        return fileURL
    }
}
