
local BugBase = class("BugBase")

BugBase.BUG_TYPE_ANT = 1
BugBase.BUG_TYPE_SPIDER = 2

function BugBase:ctor()
    self.position_ = cc.p(0, 0)
    self.rotation_ = 0
    self.type_ = BugBase.BUG_TYPE_ANT
    self.dist_ = 0
    self.distPosition_ = cc.p(0, 0)
    self.speed_ = 1
end

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

return BugBase
