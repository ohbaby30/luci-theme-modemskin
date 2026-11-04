# ModemSkin

面向 OpenWrt / ImmortalWrt 的 LuCI 主题，在同一套管理界面中提供中国电信、中国联通、中国移动三种光猫风格外观。三种外观共用 LuCI 的菜单、权限与表单机制，支持在线预览、独立保存，以及 APK / IPK 双格式构建。

## 项目来源与许可

ModemSkin 基于 [hakureiyuyuko/luci-theme-ctmodem](https://github.com/hakureiyuyuko/luci-theme-ctmodem) 继续开发，继承基线为 [`e74b366701c97a10c1b2f94057f21c46cfadbf4f`](https://github.com/hakureiyuyuko/luci-theme-ctmodem/tree/e74b366701c97a10c1b2f94057f21c46cfadbf4f)。**电信版的基础布局、部分模板、样式及光猫界面切图来源于该上游项目**，本仓库保留原作者的版权与 MIT 许可声明。

在此基础上，Ohbaby 扩展了联通与移动外观，并对导航兼容、外观保存、组件显示及打包流程进行了开发和修正。联通、移动外观参考公开设备界面，以本地 CSS、SVG 和原生 JavaScript 实现；参考文章截图未作为主题运行资源分发。

本项目代码采用 [MIT License](LICENSE)，保留 `hakureiyuyuko` 与 `Ohbaby` 的贡献署名。继承范围、界面参考和第三方素材说明见 [NOTICE.md](NOTICE.md)。运营商品牌标识与设备素材的相关权利归各自权利人所有；代码许可证不构成品牌授权或运营商背书。

## 主要功能与改进

| 方面 | ModemSkin 的实现 |
| --- | --- |
| 三种外观 | 保留电信橙蓝风格，新增联通白色配置页与移动青色网关风格；登录页跟随已保存外观。 |
| 在线切换 | 切换时加载目标外观样式，不重建插件内容；保留当前页面的输入、标签页与原生弹窗状态。 |
| 导航兼容 | 按 LuCI 实际菜单和访问权限生成导航，处理多层菜单及路由关系，支持现代 JS 页面与 Lua/CBI 兼容页面。 |
| 组件适配 | 修正日志文本框宽度、导航遮挡，以及表单、下拉框、弹窗、文件浏览器和窄屏布局等显示问题。 |
| 独立保存 | 外观使用独立配置与固定用途 RPC；保存外观不会触发全局配置应用，也不会提交或清除其他待应用配置。 |
| 资源控制 | 共用组件样式，按需加载当前外观 CSS；构建时压缩 JS/CSS；不新增常驻服务、数据库、轮询或前端框架。 |
| 构建与分发 | 一次 GitHub Actions 运行生成 APK 和 IPK，并提供 SHA256 校验清单。两种格式共用同一份运行文件。 |

兼容性以 LuCI 的通用菜单和组件机制为基础，不以隐藏插件功能来简化界面。上述改进不意味着已经覆盖所有第三方插件或历史固件。

## 适用环境

- 使用现代 **ucode LuCI** 的 OpenWrt / ImmortalWrt。
- APK 包用于使用 `apk` 的固件；IPK 包用于使用 `opkg` 的固件，按当前固件选择一种格式。
- 包含 CSS、JavaScript、ucode 模板和素材，不含平台相关的本地二进制；APK 使用 `noarch`，IPK 使用 `all`。
- 运行时依赖 `luci-base` 及其 LuCI / rpcd / ucode 依赖链。路由器无需安装 Node.js、npm 或 Docker。

**IPK 格式本身不代表兼容旧版 LuCI。** 仅支持旧 Lua 主题模板的历史固件不在当前支持范围内。

### 当前发行标识

仓库名称为 ModemSkin。当前发行包与已测试安装保持以下技术标识：

| 项目 | 标识 |
| --- | --- |
| 软件包 | `luci-theme-ctmodem-tricolor` |
| LuCI 主题选项 | `CTModem_Tricolor` |
| 静态资源目录 | `/luci-static/ctmodem-tricolor` |
| 外观配置 | `/etc/config/ctmodem_tricolor` |

## 获取安装包

进入本仓库的 **Actions**，选择 **Build ModemSkin APK and IPK → Run workflow**。运行成功后，从该次运行的 **Artifacts** 下载 `modemskin-apk-ipk`。

附件包含：

- `.apk` 安装包；
- `.ipk` 安装包；
- `SHA256SUMS` 校验文件；
- APK / IPK 包元信息。

工作流仅需读取仓库，不需要额外配置 Secrets，也不会自动创建 Release。

## 安装与使用

将对应安装包上传到路由器 `/tmp/`，在路由器终端执行与固件匹配的命令。

### APK 固件

```sh
apk add --allow-untrusted /tmp/luci-theme-ctmodem-tricolor-1.0.0-r5.apk
```

### IPK 固件

```sh
opkg install /tmp/luci-theme-ctmodem-tricolor_1.0.0-r5_all.ipk
```

上述文件名对应当前版本；后续版本请替换为实际下载文件名。安装后进入 **系统 → 系统 → 语言和界面**（部分版本称“语言和样式”），选择 **CTModem_Tricolor**，保存并应用。

安装只注册主题，不自动切换当前主题，不修改网络、代理配置或登录密码。安装、更新及卸载会重新加载现有 rpcd 扩展，LuCI RPC 请求可能短暂受影响；不会重启网络、代理或路由器。

### 切换运营商外观

在右上角的“外观”下拉框选择电信、联通或移动：

- 选择后立即预览；点击 **保存外观**，才会跨菜单、刷新和重启保留。
- **撤销预览** 恢复最后保存的外观；未保存的预览会在重新加载页面后恢复保存值。
- 外观是路由器共享配置。只读账号可以预览，具备主题写权限的账号可以保存。
- “快捷入口”按当前 LuCI 菜单与权限生成，不替换 LuCI 默认首页。

### 更新与卸载

普通更新直接安装更高版本的软件包，已修改的外观配置由包管理器保留。若产生 `.apk-new` 或 opkg 配置副本，应先核对再处理。`opkg --force-reinstall` 会按删除再安装处理，可能触发主题回退，需要重新选择主题。

卸载前先切换到已安装的其他主题，例如 Bootstrap，再执行对应命令：

```sh
# APK 固件
apk del luci-theme-ctmodem-tricolor

# IPK 固件
opkg remove luci-theme-ctmodem-tricolor
```

卸载钩子包含其他已安装主题的回退处理，但建议先手动切换。请自行备份修改过的配置。

## 本地构建

构建电脑需要 Docker、Node.js 22 和 curl。在仓库根目录执行，输出目录必须位于源码目录之外：

```sh
sh scripts/build-in-docker.sh "$PWD/../build/modemskin" both
```

第二参数支持 `apk`、`ipk`、`both`；省略时仅构建 APK。

JS/CSS 使用锁定版本的 esbuild 压缩；APK、IPK 的打包环境固定 Docker 镜像摘要。IPK 使用固定提交并校验 SHA256 的 OpenWrt 官方 `ipkg-build`。构建依赖与中间文件不进入安装包。

如需集成固件，可将 `luci-theme-ctmodem-tricolor/` 放入已配置 LuCI feed 的构建树。完整固件构建不属于当前已完成的验证范围。

## 验证范围

本地隔离环境已检查原生 LuCI 设置、PassWall2、OpenClash、现代表单、旧 CBI、自定义模板、权限菜单及常见交互组件，并检查外观切换与响应式布局。

打包流程已分别在 APK 环境和官方 OpenWrt 24.10.4 根文件系统的 opkg 环境中验证安装、正常升级、配置保留和卸载回退；IPK 环境使用官方源的现代 LuCI。测试环境不等于所有实际设备，第三方插件、固件分支和 LuCI 版本差异仍可能需要适配。

本地构建验证与 GitHub 托管工作流运行状态应分别判断。远端运行结果以本仓库 Actions 页面为准。

## 常见问题

**切换外观后，进入其他菜单又恢复了原来的样式。**

选择仅执行预览，请点击“保存外观”。

**更新后页面仍显示旧样式。**

强制刷新浏览器缓存；macOS 可使用 `Command + Shift + R`。

**能够预览，但无法保存。**

检查登录会话和主题写权限，必要时重新登录。保存接口只接受电信、联通、移动三种预设值；配置损坏时应先检查外观配置文件。

**为什么包名仍包含 ctmodem-tricolor？**

这是当前发行包沿用的技术标识，与 ModemSkin 的仓库名称不同。请以本 README 列出的包名和主题选项安装使用。
