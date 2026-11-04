# ModemSkin

为 OpenWrt / ImmortalWrt 的 LuCI 管理界面提供中国电信、中国联通、中国移动三种光猫风格外观。

## 功能特点

- 三种运营商外观在线切换，登录页随已保存的外观变化。
- 切换时保留当前页面的表单输入、标签页和弹窗状态。
- 按 LuCI 菜单与权限生成导航，兼容现代 JS 页面和 Lua/CBI 兼容页面。
- 适配常见表单、日志、下拉框及桌面和手机布局。
- 共用基础样式，按需加载外观资源；不新增常驻服务。
- 一次 GitHub Actions 构建生成 APK、IPK 和 SHA256 校验文件，并发布到 Releases。

## 适用环境

需要使用现代 **ucode LuCI** 的 OpenWrt / ImmortalWrt，并已安装 `luci-base`。仅支持旧 Lua 主题模板的历史固件不在支持范围内。

按固件的包管理器选择安装包：使用 `apk` 的固件安装 APK，使用 `opkg` 的固件安装 IPK。

## 下载与安装

在 [Releases](https://github.com/ohbaby30/luci-theme-modemskin/releases/latest) 下载对应版本的 APK 或 IPK；`SHA256SUMS` 用于校验文件完整性。

将对应安装包上传到路由器 `/tmp/`，执行以下命令之一。命令通过通配符匹配版本号，升级时也可直接使用。

**APK 固件：**

```sh
apk add --allow-untrusted /tmp/luci-theme-modemskin-*.apk
```

**IPK 固件：**

```sh
opkg install /tmp/luci-theme-modemskin_*_all.ipk
```

安装前，确保 `/tmp/` 中只放一个对应格式的 ModemSkin 安装包，避免同时匹配多个版本。

进入 **系统 → 系统 → 语言和界面**（部分版本称“语言和样式”），选择 **ModemSkin**，保存并应用。

## 使用与更新

右上角“外观”可选择电信、联通或移动。选择后立即预览，点击 **保存外观** 后，切换菜单、刷新页面或重启仍会保留；**撤销预览** 可恢复最后保存的外观。

更新时上传新安装包，执行同一条安装命令即可。更新后强制刷新浏览器；macOS 可使用 `Command + Shift + R`。

## 卸载

先切换到其他已安装的主题，再按固件的包管理器执行：

```sh
# APK 固件
apk del luci-theme-modemskin

# IPK 固件
opkg remove luci-theme-modemskin
```

## 本地构建

构建电脑需要 Docker、Node.js 22 和 curl；路由器运行主题不需要这些工具。

在仓库根目录执行，构建产物保存在源码目录之外：

```sh
sh scripts/build-in-docker.sh "$PWD/../build/modemskin" both
```

第二参数可选 `apk`、`ipk`、`both`；省略时仅构建 APK。

## 发布版本

版本使用 `主版本.次版本.修订版本`：修复问题递增最后一位，向后兼容的功能更新递增中间一位，不兼容的大改动递增第一位；递增前面的数字时，后面的数字归零。Release 标签使用 `v` 前缀，例如 `v1.1.1`。

更新 `luci-theme-modemskin/Makefile` 中的 `PKG_VERSION`，然后进入 **Actions → Build ModemSkin APK and IPK → Run workflow**。构建成功后自动创建对应版本的 Release，并上传 APK、IPK 和校验文件。同一版本不重复发布。

## 来源与许可

电信风格及部分代码、素材源自 [hakureiyuyuko/luci-theme-ctmodem](https://github.com/hakureiyuyuko/luci-theme-ctmodem)。ModemSkin 在此基础上新增联通、移动外观，并完善导航兼容、组件适配和双格式构建。

代码采用 [MIT License](LICENSE)。来源与修改说明见 [NOTICE.md](NOTICE.md)，第三方版权及许可全文见 [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md)。
