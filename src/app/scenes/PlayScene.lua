
local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

local Game = import("..models.Game")

function PlayScene:ctor()
    self.game_ = Game.new(self)

    display.newSprite("img/bg.jpg")
        :pos(display.cx, display.cy)
        :addTo(self)

    display.newSprite("img/star.png")
        :pos(display.left + 50, display.top - 50)
        :addTo(self)

    self.starsLabel_ = cc.ui.UILabel.new({
            text = self.game_:getStars(),
            x = display.left + 90,
            y = display.top - 50,
            size = 32})
        :addTo(self)
end

function PlayScene:onEnter()
    self.game_:addEventListener(Game.BUG_ENTER_HOLE_EVENT, function(event)
        self.starsLabel_:setString(self.game_:getStars())
    end)

    self.game_:addEventListener(Game.PLAYER_DEAD_EVENT, handler(self, self.onPlayerDead_))

    self:schedule(function()
        self.game_:step()
    end, 0.02)

    self.game_:addBug()
    self:schedule(function()
        self.game_:addBug()
    end, 2)

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self.game_:onTouch(event)
    end)
end

function PlayScene:onExit()
end

function PlayScene:onPlayerDead_()
    local text = string.format("你戳死了 %d 只虫子", self.game_:getDeadCount())
    cc.ui.UILabel.new({text = text, size = 96})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)

    cc.ui.UIPushButton.new("img/exit_button.png")
        :onButtonClicked(function()
            app:enterScene("MainScene", nil, "Random", 1.0)
        end)
        :pos(display.cx, display.cy - 200)
        :addTo(self)
end

return PlayScene
