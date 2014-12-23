
# 两小时学会用 cocos2d-lua 开发游戏

主题：用 cocos2d-lua 创建一个小游戏，掌握游戏开发基本概念。

## 安装配置

cocos2d-x 里已经内置了一个 lua 版本，被称为 cocos2d-lua。而 quick 是 cocos2d-lua 的一个强化版本。现在 quick 团队已经接手了 cocos2d-lua 的开发和维护工作，所以未来 quick 和 cocos2d-lua 将完全合并起来。因此，我们今天的学习也是基于 quick 来讲。

从 cn.cocos2d-x.org 下载 quick 版本后，执行安装程序即可。需要注意的问题就是不要安装到根目录，或者带有空格或中文的路径里。

安装完成，双击桌面上的 player3 图标，可以看到 quick 自带的 welcome 界面。这个界面可以用来创建、打开、编译项目。这个 player 就是 quick 里自带的模拟器，可以用来运行游戏。

### 创建工程

选择新建，选择项目放置在哪里，再输入项目的包名。这个包名有点类似域名的格式，只不过顺序相反。

接下来我们选择屏幕方向为 landscape，也就是横屏。

由于这次的学习不涉及到 C++ 部分，所以我们去掉 Copy Source Files 选项，可以加快项目创建速度。

点击 Create Project 按钮后，会出现一个终端窗口显示创建项目的结果。如果一切正常，我们就可以回到 player 里选择 Open Project 打开项目。最后关掉 welcome 界面。

<br />

## 游戏玩法

现在模拟器里已经把我们的游戏跑起来了，大大的 Hello, World 如此耀眼。

在开始写代码之前，我们明确一下游戏的玩法：

-   游戏开始后，玩家有 5 个红心。
-   从屏幕周边不断出现各种小虫子，并往屏幕另一边爬行。
-   玩家要用手指戳死虫子。
-   虫子爬到屏幕外面时，就会扣掉玩家一个红心。
-   红心被扣完后，游戏结束。
-   游戏结束时，统计玩家干掉了多少虫子。

<br />

## 开始创建游戏

第一步我们创建主菜单场景。

在编辑器中打开 `src` 目录，可以看到如下目录结构。

其中 `app` 子目录里就是放置我们的游戏代码，而 `app/scenes` 则是游戏各个场景的代码。

### 创建主菜单场景

我们可以把场景想象为舞台。当游戏进行时，只有一个舞台可以被玩家看到，所以切换场景就相当于换一个舞台。

现在我们来创建游戏的主菜单场景。打开 `app/scenes/MainScene.lua` 文件:

修改内容为：

```lua
function MainScene:ctor()
    display.newSprite("img/cover.jpg")
        :pos(display.cx, display.cy)
        :addTo(self)
end
```

按 F5 刷新一下模拟器，可以看到屏幕上的显示内容已经变了。

~

概念讲解：

-   app：游戏启动后就创建的全局对象，用于提供整个应用程序级别的功能
-   场景：定义一个舞台
-   app:run() 里将默认打开 MainScene 场景
-   什么是类和对象：把类想象为 word 的文档模板，而对象则是从模板创建出来的文档，又被称为实例。所以修改类后，基于这个类创建的对象也会具有不同的方法和属性。
-   如何定义一个类：从基础类继承、从函数创建对象
-   类的继承：子类会包含父类的方法和属性
-   调用父类方法： app 里 ctor() 方法就需要调用父类的 ctor() 方法，完成初始化工作。

~

回到 MainScene.lua，继续讲场景相关的概念：

-   坐标系：左下角原点、X/Y轴的数值变化，右上角坐标点
-   pos() 方法
-   addTo() 方法
-   屏幕分辨率：假定为 960x640，暂时不考虑多分辨率适配

在背景上放置一个虫子：

```lua
display.newSprite("img/bug1_01.png")
    :pos(display.cx, display.cy)
    :addTo(self)
```

-   层叠关系：后加入的 Sprite 会叠加在之前加入场景的 Sprite 之上
-   修改 ZOrder：修改对象的 ZOrder 可以改变这种行为

放置开始按钮：

-   使用 cc.ui.UIPushButton

```lua
cc.ui.UIPushButton.new("img/play_button.png")
    :pos(display.cx, display.cy - 200)
    :addTo(self)
```

增加点击事件处理：

-   onButtonClicked() 方法

```lua
cc.ui.UIPushButton.new("img/play_button.png")
    :onButtonClicked(function()
        print("PLAY BUTTON CLICKED")
    end)
    :pos(display.cx, display.cy - 200)
    :addTo(self)
```

<br />

### 创建游戏场景

创建 `app/scenes/PlayScene.lua`，并从 `app/scenes/MainScene.lua` 复制内容，修改为：

```lua

local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

function PlayScene:ctor()
    display.newSprite("img/bg.jpg")
        :pos(display.cx, display.cy)
        :addTo(self)
end

function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
```

修改 `MainScene`，在点击 "Play" 按钮时切换到新场景：

```lua
:onButtonClicked(function()
    app:enterScene("PlayScene")
end)
```

增加一点切换效果：

```lua
:onButtonClicked(function()
    app:enterScene("PlayScene", nil, "Random", 1.0)
end)
```

由于随机数问题，所以我们在 app 初始化时还要初始化一下随机数种子：

```lua
function MyApp:run()
    math.newrandomseed()

    ....
end
```

添加更多元素：

```lua
cc.ui.UILabel.new({
        text = "5",
        x = display.left + 90,
        y = display.top - 50,
        size = 32})
    :addTo(self)
```

由于这个文字标签要根据玩家的 HP 来动态变化，所以我们给 `PlayScene` 对象定义两个新的属性：

```lua
self.stars_ = 5
self.starsLabel_ = cc.ui.UILabel.new({
        text = self.stars_,
        x = display.left + 90,
        y = display.top - 50,
        size = 32})
    :addTo(self)
```

<br />

## 创建游戏的玩法逻辑模型

因为游戏有两种虫子，但它们都有一些共同的行为，例如移动、钻入洞里等，所以我们定义一个名为 `BugBase` 的基础类。

增加 `app/models` 文件夹，添加文件 `BugBase.lua`:

-   添加 `Base` 表示基础类，这是一种约定，可以方便团队协作

```lua
local BugBase = class("BugBase")

return BugBase
```

添加构造函数：

```lua
function BugBase:ctor()
    self.position_ = cc.p(0, 0)
    self.rotation_ = 0
    self.type_ = 1
end
```

定义了虫子的初始位置、角度和类型。但我们不应该使用数字或字符串来直接定义类型，而是应该使用更容易阅读和维护的形式：

```lua
BugBase.BUG_TYPE_ANT = 1
BugBase.BUG_TYPE_SPIDER = 2

function BugBase:ctor()
    self.position_ = cc.p(0, 0)
    self.rotation_ = 0
    self.type_ = BugBase.BUG_TYPE_ANT
end
```

添加两种虫子的类文件，并且在构造函数中指定虫子的类型。

-   讲解 `import()` 函数的用法

虫子是随机出现在屏幕四周，往屏幕中间的洞移动，所以我们需要一个方法来初始化虫子位置和方向。由于这个方法是两种虫子都需要的，所以定义在 `BugBase` 里：

```lua
function BugBase:setInitPosition(holePosition, rotation, dist)
    -- 确定虫子从洞的哪个角度出现
    local rotation = rotation or math.random(0, 360)
    -- 转为弧度
    local radians = rotation * math.pi / 180

    -- 确定虫子与洞的初始距离
    -- 这里偷懒确定初始距离总是比半个屏幕的宽度多一些，避免虫子一出来时就在屏幕上
    -- 严格的算法应该是屏幕四周与指定角度射线的交点距离
    local dist = dist or math.random(display.width / 2 + 200, display.width / 2 + 500)

    -- 计算虫子的初始位置和角度
    self.position_ = cc.p(holePosition.x + math.cos(radians) * dist,
                          holePosition.y - math.sin(radians) * dist)

    -- 因为需要虫子的头对着洞，所以虫子的方向实际上要旋转 180 度
    self.rotation_ = rotation - 180

    return self
end
```

-   cocos2dx 里，0 度正对右方，所以虫子图片里虫子的头部也是正对右方
-   为什么要返回 `self`

试试看在场景里加入虫子。由于需要读取虫子对象的属性，所以还要为 `BugBase` 再添加一些读取属性的方法：

```lua
function BugBase:getPosition()
    return self.position_.x, self.position_.y
end

function BugBase:getRotation()
    return self.rotation_
end

function BugBase:getType()
    return self.type_
end

function BugBase:getDist()
    return self.dist_
end

function BugBase:setDistPosition(holePosition)
    self.distPosition_ = clone(holePosition)
    return self
end
```

修改 `PlayScene`：

```lua
local BugAnt = import("..models.BugAnt")

----

function PlayScene:ctor()
    ....

    local bug = BugAnt.new()
    bug:setInitPosition(cc.p(display.cx - 30, display.cy - 75), math.random(0, 360), 200)

    display.newSprite("img/bug1_01.png")
        :pos(bug:getPosition())
        :rotation(bug:getRotation())
        :addTo(self)
end
```

-   顺便讲解一下 `import()` 里多个 `.` 的意义

这里显示创建了虫子对象，然后创建图片，并按照虫子对象的属性来设置图片位置和方向。多刷新几次模拟器，看看虫子是否始终正对着洞。

这里可以看到传给 `setInitPosition()` 方法的洞位置是一个特定值，对于这种值也应该定义为更有意义的名字。

创建 `app/models/Game.lua` 文件，内容为：

```lua
local Game = class("Game")

Game.HOLE_POSITION = cc.p(display.cx - 30, display.cy - 75)

return Game
```

修改 `PlayScene`:

```lua
local Game = import("..models.Game")

----

bug:setInitPosition(Game.HOLE_POSITION, math.random(0, 360), 200)
```

<br />

实现虫子的移动：

-   添加更多属性和方法

```lua
function BugBase:ctor()
    ....

    self.dist_ = 0
    self.distPosition_ = cc.p(0, 0)
    self.speed_ = 1
end
```

添加移动方法：

```lua
function BugBase:step()
    -- 每执行一次，让虫子往目的地方向移动一点点
    self.distPosition_ = self.distPosition_ - self.speed_

    local radians = (self.rotation_ + 180) * math.pi / 180
    self.position_ = cc.p(self.distPosition_.x + math.cos(radians) * self.dist_,
                          self.distPosition_.y - math.sin(radians) * self.dist_)

    return self
end
```

可以看到 `step()` 方法和 `setInitPosition()` 方法里的计算是一样的，所以可以重构一下代码：

```lua
function BugBase:setInitPosition(holePosition, rotation, dist)
    -- 确定虫子从洞的哪个角度出现
    local rotation = rotation or math.random(0, 360)
    -- 确定虫子与洞的初始距离
    -- 这里偷懒确定初始距离总是比半个屏幕的宽度多一些，避免虫子一出来时就在屏幕上
    -- 严格的算法应该是屏幕四周与指定角度射线的交点距离
    self.dist_ = dist or math.random(display.width / 2 + 200, display.width / 2 + 500)

    -- 计算虫子的初始位置和角度
    self.position_ = self:calcPosition_(rotation, self.dist_, holePosition)

    -- 因为需要虫子的头对着洞，所以虫子的方向实际上要旋转 180 度
    self.rotation_ = rotation - 180

    -- 设置目的地位置
    self:setDistPosition(holePosition)
    return self
end

function BugBase:step()
    -- 每执行一次，让虫子往目的地方向移动一点点
    self.dist_ = self.dist_ - self.speed_
    self.position_ = self:calcPosition_(self.rotation_ + 180, self.dist_, self.distPosition_)
    return self
end

function BugBase:calcPosition_(rotation, dist, distPosition)
    local radians = rotation * math.pi / 180
    return cc.p(distPosition.x + math.cos(radians) * dist,
                distPosition.y - math.sin(radians) * dist)
end
```

-   注意在 `setInitPosition()` 里调用了 `setDistPosition()`

修改 `PlayScene`，执行一个循环，看看虫子的移动效果：

```lua
function PlayScene:ctor()
    ....

    local bug = BugAnt.new()
    bug:setInitPosition(Game.HOLE_POSITION, math.random(0, 360), 200)

    local bugSprite = display.newSprite("img/bug1_01.png")
        :pos(bug:getPosition())
        :rotation(bug:getRotation())
        :addTo(self)

    self:schedule(function()
        bug:step()
        bugSprite:pos(bug:getPosition())
        print(bug:getDist())
    end, 0.1)
end
```

可以看到虫子在不断往洞靠近。

<br />

现在我们需要在场景里添加多个虫子，并且让这些虫子动起来。

-   在 `Game` 对象里处理所有虫子的移动和图像

