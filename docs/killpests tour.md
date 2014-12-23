# killpests tour

## 安装 quick

cocos2d-x 里已经内置了一个 lua 版本，被称为 cocos2d-lua。而 quick 是 cocos2d-lua 的一个强化版本。现在 quick 团队已经接手了 cocos2d-lua 的开发和维护工作，所以未来 quick 和 cocos2d-lua 将完全合并起来。因此，我们今天的学习也是基于 quick 来讲。

从 cn.cocos2d-x.org 下载 quick 版本后，执行安装程序即可。需要注意的问题就是不要安装到根目录，或者带有空格或中文的路径里。

安装完成，双击桌面上的 player3 图标，可以看到 quick 自带的 welcome 界面。这个界面可以用来创建、打开、编译项目。


## 创建工程

选择新建，选择项目放置在哪里，再输入项目的包名。这个包名有点类似域名的格式，只不过顺序相反。

接下来我们选择屏幕方向为 landscape，也就是横屏。

由于这次的学习不涉及到 C++ 部分，所以我们去掉 Copy Sources 选项，圣迪奥

