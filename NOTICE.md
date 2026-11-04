# 来源与修改

本项目基于 [hakureiyuyuko/luci-theme-ctmodem](https://github.com/hakureiyuyuko/luci-theme-ctmodem)，基线提交 `e74b366701c97a10c1b2f94057f21c46cfadbf4f`。保留原 MIT 许可证及作者版权声明。

CTModem Tricolor 的修改包括独立主题路径、LuCI 条件字段和状态指示器支持、递归导航、局部表单标签布局、动态进度数字、登录返回路径及 APK 构建流程。

`img/` 中的光猫界面切图沿用上游素材。上游说明这些是设备原始素材；原有品牌标识不代表本项目获得品牌方认可。MIT 许可证保留并不构成额外的品牌或第三方素材授权。

## Tricolor 独立派生

本版本从本地 CTModem Ohbaby 1.0.0-r5 派生，旧电信项目保持不变。新增三种外观分离加载、右上角预览/保存、固定用途主题 RPC、独立配置、快捷入口和共存/回退支持；新增代码由 Ohbaby 维护。

联通布局参考 https://inkflow.cc/other/64.html 中 F657GV9 的白色配置界面；移动布局参考 https://www.cnblogs.com/scoluo/p/13945175.html 中 GS3101 的青色界面。采用重新绘制的布局、文字和简化图标，原文截图没有进入生产安装包。

## Tricolor r3 login presentation

Carrier login decoration SVGs are locally drawn for this theme. Layout references: https://inkflow.cc/other/64.html (F657GV9 welcome screen), https://blog.csdn.net/coolfax/article/details/136924260 (ZN-AX173G cyan login panel). Article screenshots, QR codes, device credentials and registration actions are not distributed. Brand names identify the selected visual style; this theme is an independent LuCI implementation.

## 新增与修改部分的署名

Copyright (c) 2026 Ohbaby。Ohbaby 的新增与修改部分按 MIT 许可证发布，包括三运营商外观切换、独立外观配置与保存接口、联通/移动样式、登录页装饰以及本项目的兼容性修改。该署名不替代上游版权声明，不主张取得上游代码或第三方品牌/素材的所有权；适用的上游及第三方声明继续保留。
