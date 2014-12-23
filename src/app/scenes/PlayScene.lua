
local PlayScene = class("PlayScene", function()
    return display.newScene("PlayScene")
end)

local Game = import("..models.Game")

function PlayScene:ctor()
    display.newSprite("img/bg.jpg")
        :pos(display.cx, display.cy)
        :addTo(self)

    display.newSprite("img/star.png")
        :pos(display.left + 50, display.top - 50)
        :addTo(self)


    self.stars_ = 5
    self.starsLabel_ = cc.ui.UILabel.new({
            text = self.stars_,
            x = display.left + 90,
            y = display.top - 50,
            size = 32})
        :addTo(self)

    self.game_ = Game.new(self)

    self:schedule(function()
        self.game_:step()
    end, 0.02)

    self.game_:addBug()
    self:schedule(function()
        self.game_:addBug()
    end, 2)
end

function PlayScene:onEnter()
end

function PlayScene:onExit()
end

return PlayScene
