# Open1PanelApp 项目规则

## UI框架
- 统一使用 **Material Design 3 (MDUI3)** 规范
- iOS平台液态玻璃组件使用原生Swift实现

## 代码规范
- 使用 `const` 构造函数优化性能
- 使用 `Theme.of(context)` 获取主题色，禁止硬编码颜色
- 支持深色模式，使用 `colorScheme`

## 文件组织
```
lib/
├── core/           # 核心配置、主题、常量
├── data/           # 数据模型、仓库
├── features/       # 功能模块
└── shared/         # 共享组件
```

## 详细规范
- [UI设计规范](ui_rules.md)
- [开发规范](dev_rules.md)
