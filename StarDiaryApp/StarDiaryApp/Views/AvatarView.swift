//
//  AvatarView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI

// AvatarView：显示用户头像
// 如果用户没有设置头像，则显示默认图标
struct AvatarView: View {
    let avatarURL: URL? // 用户头像的URL

    var body: some View {
        Group {
            if let url = avatarURL,
               let data = try? Data(contentsOf: url), // 尝试加载头像数据
               let uiImage = UIImage(data: data) { // 将数据转换为图片
                // 显示用户头像
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                // 显示默认头像
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
            }
        }
        .clipShape(Circle()) // 将头像裁剪为圆形
    }
}
