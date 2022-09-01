[点击访问Github同源仓库](https://github.com/xusun0623/river_lite)   
   
   
   

![输入图片说明](App%20Icon.png)

# 河畔Lite App
本Repo是电子科技大学官方校园论坛【清水河畔】的第三方客户端的开源代码仓库。此App轻量、简洁、设计优雅，拥有诸多特性和功能。  

## 客户端下载（【提取码均为1234】）
安卓客户端：[点击前往跳转下载安卓客户端](https://wwb.lanzouj.com/b027a448b)  
IOS客户端：[点击访问AppStore下载客户端](https://apps.apple.com/cn/app/河畔lite/id1620829749)  
MacOS客户端：[点击前往跳转下载MacOS客户端](https://wwb.lanzouj.com/b027gge2d)  

## Flutter框架信息
本项目使用Google开源的跨端页面构建框架Flutter，使用Skia调用GPU直接渲染，渲染速度和表现力十分优秀，并可以移植到macOS、Windows、Linux、Android、IOS等诸多平台。现已在app Store上架Release版本「河畔Lite」，对应的安卓版本也在站内个人主页帖子发布，感兴趣的同学欢迎体验！！  

## 编译此项目
```
Windows环境
1.首先你需要配置Flutter开发环境，可以参照如下链接
https://doc.flutterchina.club/setup-windows

2.编译到安卓/鸿蒙客户端
 ·下载Android Studio，并首次运行，下载安卓SDK
 ·使用Git克隆此项目，用Visual Studio Code打开（需安装flutter扩展，仅安装这一个即可）
 ·使用数据线连接你的手机，并在安卓/鸿蒙手机上开启「开发者调试」
 ·在VSCode右下角会出现手机的标识，说明连接成功
 ·在/offershow/android/gradle/wrapper目录下放置Gradle包，并重命名为gradle-7.4-all.zip，下载地址为：https://services.gradle.org/distributions/gradle-7.4-all.zip，推荐使用迅雷下载
 ·在lib/main.dart的mainApp入口上方，点击run app，等待构建完成即可
```
```
MacOS环境
1.首先你需要配置Flutter开发环境，可以参照如下链接
https://doc.flutterchina.club/setup-macos  

2.编译到IOS
 ·下载Xcode，并首次运行，下载安卓SDK
 ·使用Git克隆此项目，用Visual Studio Code打开（需安装flutter扩展，仅安装这一个即可）
 ·运行flutter doctor命令，检查环境是否问题，仅检查vscode和xcode项目即可
 ·使用数据线连接你的手机，点击信任设备（或者在terminal输入open -a simulator启动IOS模拟器）
 ·在VSCode右下角会出现手机的标识，说明连接成功
 ·在lib/main.dart的mainApp入口上方，点击run app，等待构建完成即可  

3.编译到MacOS
 ·下载Xcode，并首次运行，下载安卓SDK
 ·使用Git克隆此项目，用Visual Studio Code打开（需安装flutter扩展，仅安装这一个即可）
 ·运行flutter doctor命令，检查环境是否问题，仅检查vscode和xcode项目即可
 ·在VSCode右下角会出现MacOS的标识，说明配置成功
 ·在lib/main.dart的mainApp入口上方，点击run app，等待构建完成即可  
```

## 联系作者
mail：xusun000@foxmail.com  
QQ：2235861811（加好友时请注明来意）  
Gitee主页：[点我访问](https://gitee.com/xusun000)  

## 设计文件
figma在线设计工具：[点我访问](https://www.figma.com/file/McSp35qqjsUuWAbucxXdXn/%E6%B2%B3%E7%95%94Max%E7%89%88-XS-Designed)  
宣传图：
![设计宣传图](hola.png)

## 功能一览  
#### 帖子相关
```
- 发帖（附加文字、图片、链接、表情包和附件等等）  
- 查看帖子，通过图文混排的模式和小图预览的模式查看帖子  
- 搜索帖子，并带有搜索历史  
- 回帖，针对帖子内容你可以发送文字/图/表情包/附件📎  
- 加水滴、扣水滴  
- 分享帖子、举报帖子  
- 复制帖子文本内容  
- 保存单张图片/一键保存所有图片  
- 图文预览  
- 帖子收藏  
- 评论置顶  
- 帖子专栏  
```

#### 用户相关
```
- 查看用户的水滴、头像图片、各种其余用户信息  
- 私聊用户、关注用户  
- 搜索用户，并带有搜索历史  
- 查看用户的发表、回复、收藏内容  
- 拉黑用户  
```

#### 私信相关
```
- 发送文本  
- 发送图片  
- 接受艾特、回复、系统通知、私信信息  
- 查看最近100条私信信息  
```

#### 水滴相关
```
- 获取水滴任务  
- 获取水滴答题题目  
- 水滴自动答题  
```

#### 其余功能
```
- 点击用户插画可以更改性别  
- 长按搜索历史可以删除单个记录  
- 在专栏下点按加号可以迅速定位到对应的板块发帖  
- 长按用户评论可以勾选+1  
- 管理员可以在附加的链接中对帖子进行管理  
- 长按链接可以直接复制  
- 附件上传支持flv,mp3,mp4,zip,rar,tar,gz,xz,bz2,7z,apk,ipa,crx,pdf,caj,ppt,pptx,doc,docx,xls,xlsx,txt,png,jpg,jpe,jpeg,gif格式文件  
- 个人页面的收藏、我的发表、我的回复、浏览历史、草稿箱按钮支持Hero动画  
- 长按用户头像可以手动清除头像图片缓存  
- 首页请求时会缓存接口数据，对请求进行加速  
```
