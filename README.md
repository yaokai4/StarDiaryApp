# StarDiaryApp
StarDiaryApp開発中
StarDiaryApp/
├─ StarDiaryApp.swift         // App入口
├─ UserViewModel.swift        // 用户数据与状态管理
├─ DiaryViewModel.swift       // 日记与文件夹数据管理
├─ Models/
│   ├─ User.swift             // 用户模型
│   ├─ Folder.swift           // 文件夹模型
│   ├─ DiaryEntry.swift       // 日记数据模型
├─ Views/
│   ├─ ContentView.swift      // 主内容视图，含TabView
│   ├─ HomeView.swift         // 主页视图
│   ├─ FolderDetailView.swift // 文件夹详情视图（含日记和文件夹的管理）
│   ├─ DiaryDetailView.swift  // 日记详情视图
│   ├─ DiaryEditView.swift    // 日记添加/编辑页面
│   ├─ CategoriesView.swift   // 分类页面
│   ├─ PersonalInfoView.swift // 个人信息页面
│   ├─ AvatarView.swift       // 头像组件
└─ Utils/
    ├─ MediaManager.swift     // 媒体文件管理工具
