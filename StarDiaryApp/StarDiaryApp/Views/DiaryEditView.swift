//
//  DiaryEditView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//
import SwiftUI
import PhotosUI

// DiaryEditView：日记添加/编辑页面
// 用户可以在此页面编辑日记的标题、内容、分类，并上传图片
struct DiaryEditView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel // 从环境中获取日记视图模型
    @Environment(\.presentationMode) var presentationMode // 控制页面的显示与隐藏

    var folder: Folder // 当前日记所属文件夹
    var entry: DiaryEntry? // 编辑的日记对象，nil 表示添加新日记

    @State private var title: String
    @State private var content: String
    @State private var category: String
    @State private var imageURLs: [URL]

    @State private var showingImagePicker = false // 控制图片选择器的显示状态
    @State private var selectedPhotos: [PhotosPickerItem] = [] // 用户选择的图片

    init(folder: Folder, entry: DiaryEntry?) {
        self.folder = folder
        self.entry = entry
        // 初始化状态变量
        _title = State(initialValue: entry?.title ?? "")
        _content = State(initialValue: entry?.content ?? "")
        _category = State(initialValue: entry?.category ?? "未分类")
        _imageURLs = State(initialValue: entry?.imageURLs ?? [])
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标题")) {
                    TextField("输入标题", text: $title)
                }
                Section(header: Text("内容")) {
                    TextEditor(text: $content)
                        .frame(height: 150) // 设置多行文本框的高度
                }
                Section(header: Text("分类")) {
                    TextField("输入分类", text: $category)
                }
                Section(header: Text("图片附件")) {
                    // 显示已添加的图片
                    ForEach(imageURLs, id: \.self) { url in
                        if let data = try? Data(contentsOf: url),
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
                                .clipped()
                        }
                    }
                    Button("添加图片") {
                        showingImagePicker = true // 显示图片选择器
                    }
                }
            }
            .navigationBarTitle(entry == nil ? "添加日记" : "编辑日记", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss() // 返回上一页
                },
                trailing: Button("保存") {
                    saveEntry() // 保存日记
                }
            )
            .photosPicker(isPresented: $showingImagePicker, selection: $selectedPhotos, matching: .images)
            .onChange(of: selectedPhotos) { newItems in
                handleNewPhotos(newItems) // 处理新选择的图片
            }
        }
    }

    private func saveEntry() {
        // 确保标题和内容不为空
        guard !title.isEmpty, !content.isEmpty else { return }
        if let entry = entry {
            // 更新已有日记
            diaryViewModel.updateEntry(entry, title: title, content: content, category: category, images: imageURLs)
        } else {
            // 添加新日记
            diaryViewModel.addEntry(title: title, content: content, category: category, folder: folder, images: imageURLs)
        }
        presentationMode.wrappedValue.dismiss() // 保存后返回上一页
    }

    private func handleNewPhotos(_ items: [PhotosPickerItem]) {
        // 异步加载新选择的图片并保存
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let url = try? MediaManager.shared.saveMedia(data: data, fileExtension: "jpg") {
                    imageURLs.append(url)
                }
            }
        }
    }
}
