//
//  EntryDetailView.swift
//  StarDiaryApp
//
//  Created by Yao Kai on 2024/12/19.
//

import SwiftUI

struct EntryDetailView: View {
    @EnvironmentObject var viewModel: DiaryViewModel // 日记数据环境对象
    @Environment(\.presentationMode) var presentationMode // 控制视图呈现模式
    
    let entry: DiaryEntry // 当前编辑的日记条目
    @State private var title: String
    @State private var content: String
    @State private var category: String
    
    init(entry: DiaryEntry) {
        self.entry = entry
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _category = State(initialValue: entry.category)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("标题")) {
                    TextField("标题", text: $title)
                }
                Section(header: Text("内容")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
                Section(header: Text("分类")) {
                    TextField("分类", text: $category)
                }
            }
            .navigationBarTitle("编辑日记", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    // 取消编辑
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    // 保存编辑结果
                    viewModel.updateEntry(entry,
                                          title: title,
                                          content: content,
                                          category: category,
                                          images: entry.imageURLs)

                    presentationMode.wrappedValue.dismiss()
                }.disabled(title.isEmpty || content.isEmpty)
                // 当标题或内容为空时禁用保存按钮
            )
        }
    }
}
