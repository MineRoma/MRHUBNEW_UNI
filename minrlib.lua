--[[
    MinrLib - UI Library
]]

local MinrLib = {}

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local GuiParent
pcall(function()
    GuiParent = game:GetService("CoreGui")
end)
if not GuiParent then
    GuiParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local Player = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Темы
MinrLib.Themes = {
    Default = {
        Background = Color3.fromRGB(25, 25, 30),
        TopBar = Color3.fromRGB(20, 20, 25),
        TabBar = Color3.fromRGB(30, 30, 35),
        Tab = Color3.fromRGB(40, 40, 45),
        TabActive = Color3.fromRGB(80, 100, 220),
        Element = Color3.fromRGB(35, 35, 40),
        ElementHover = Color3.fromRGB(45, 45, 50),
        Toggle = Color3.fromRGB(50, 50, 55),
        ToggleEnabled = Color3.fromRGB(80, 170, 120),
        Accent = Color3.fromRGB(80, 100, 220),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(170, 170, 180)
    },
    Ocean = {
        Background = Color3.fromRGB(20, 35, 50),
        TopBar = Color3.fromRGB(15, 30, 45),
        TabBar = Color3.fromRGB(25, 40, 55),
        Tab = Color3.fromRGB(35, 50, 65),
        TabActive = Color3.fromRGB(0, 150, 200),
        Element = Color3.fromRGB(30, 45, 60),
        ElementHover = Color3.fromRGB(40, 55, 70),
        Toggle = Color3.fromRGB(40, 55, 70),
        ToggleEnabled = Color3.fromRGB(0, 150, 200),
        Accent = Color3.fromRGB(0, 150, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 180, 200)
    },
    Purple = {
        Background = Color3.fromRGB(30, 25, 45),
        TopBar = Color3.fromRGB(25, 20, 40),
        TabBar = Color3.fromRGB(35, 30, 50),
        Tab = Color3.fromRGB(45, 40, 60),
        TabActive = Color3.fromRGB(140, 90, 200),
        Element = Color3.fromRGB(40, 35, 55),
        ElementHover = Color3.fromRGB(50, 45, 65),
        Toggle = Color3.fromRGB(50, 45, 65),
        ToggleEnabled = Color3.fromRGB(140, 90, 200),
        Accent = Color3.fromRGB(140, 90, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 170, 200)
    }
}

-- Утилиты
local function Tween(obj, props, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function Stroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 65),
        Thickness = thickness or 1,
        Parent = parent
    })
end

function MinrLib:CreateWindow(config)
    config = config or {}
    
    local WindowConfig = {
        Name = config.Name or "MinrLib",
        Theme = config.Theme or "Default",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
    }
    
    self.Theme = self.Themes[WindowConfig.Theme] or self.Themes.Default
    local Theme = self.Theme
    
    local ScreenGui = Create("ScreenGui", {
        Name = "MinrLib",
        Parent = GuiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local NotifContainer = Create("Frame", {
        Name = "Notifications",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 320, 0, 400)
    })
    
    Create("UIListLayout", {
        Parent = NotifContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8)
    })
    
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = IsMobile and UDim2.new(0.95, 0, 0.7, 0) or UDim2.new(0, 550, 0, 400),
        ClipsDescendants = true,
        BackgroundTransparency = 1
    })
    Corner(Main, 10)
    
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = Main,
        BackgroundColor3 = Theme.TopBar,
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1
    })
    Corner(TopBar, 10)
    
    local Title = Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowConfig.Name,
        TextColor3 = Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })
    
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(220, 70, 70),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        BackgroundTransparency = 1
    })
    Corner(CloseBtn, 8)
    
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(220, 160, 70),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -50, 0.5, 0),
        Size = UDim2.new(0, 32, 0, 32),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        BackgroundTransparency = 1
    })
    Corner(MinimizeBtn, 8)
    
    local TabBar = Create("Frame", {
        Name = "TabBar",
        Parent = Main,
        BackgroundColor3 = Theme.TabBar,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1
    })
    
    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        Parent = TabBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 1, -10),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    Create("UIListLayout", {
        Parent = TabScroll,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    })
    
    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 90),
        Size = UDim2.new(1, 0, 1, -90)
    })
    
    local MobileBtn
    if IsMobile then
        MobileBtn = Create("TextButton", {
            Name = "MobileToggle",
            Parent = ScreenGui,
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 15, 0.5, -25),
            Size = UDim2.new(0, 50, 0, 50),
            Font = Enum.Font.GothamBold,
            Text = "☰",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 22
        })
        Corner(MobileBtn, 25)
    end
    
    local Window = {
        Gui = ScreenGui,
        Main = Main,
        TabScroll = TabScroll,
        ContentContainer = ContentContainer,
        NotifContainer = NotifContainer,
        Theme = Theme,
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        Visible = true
    }
    
    -- Анимация появления
    Main.Size = IsMobile and UDim2.new(0.95, 0, 0, 0) or UDim2.new(0, 550, 0, 0)
    
    task.spawn(function()
        task.wait(0.1)
        Tween(Main, {BackgroundTransparency = 0, Size = IsMobile and UDim2.new(0.95, 0, 0.7, 0) or UDim2.new(0, 550, 0, 400)}, 0.4)
        Tween(TopBar, {BackgroundTransparency = 0}, 0.4)
        Tween(TabBar, {BackgroundTransparency = 0}, 0.4)
        Tween(Title, {TextTransparency = 0}, 0.4)
        Tween(CloseBtn, {BackgroundTransparency = 0}, 0.4)
        Tween(MinimizeBtn, {BackgroundTransparency = 0}, 0.4)
    end)
    
    -- Драг окна
    local dragging, dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Window.Visible = false
        Tween(Main, {Size = IsMobile and UDim2.new(0.95, 0, 0, 0) or UDim2.new(0, 550, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(Main, {Size = IsMobile and UDim2.new(0.95, 0, 0, 45) or UDim2.new(0, 550, 0, 45)}, 0.3)
        else
            Tween(Main, {Size = IsMobile and UDim2.new(0.95, 0, 0.7, 0) or UDim2.new(0, 550, 0, 400)}, 0.3)
        end
    end)
    
    if not IsMobile then
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == WindowConfig.ToggleKey then
                Window.Visible = not Window.Visible
                Main.Visible = Window.Visible
            end
        end)
    end
    
    if MobileBtn then
        MobileBtn.MouseButton1Click:Connect(function()
            Window.Visible = not Window.Visible
            Main.Visible = Window.Visible
        end)
    end
    
    -- Notify
    function Window:Notify(config)
        config = config or {}
        local notifConfig = {
            Title = config.Title or "Notification",
            Text = config.Text or "",
            Duration = config.Duration or 5,
            Type = config.Type or "Info"
        }
        
        local colors = {
            Info = Theme.Accent,
            Success = Color3.fromRGB(80, 180, 120),
            Warning = Color3.fromRGB(220, 160, 70),
            Error = Color3.fromRGB(220, 70, 70)
        }
        
        local icons = {Info = "ℹ", Success = "✓", Warning = "⚠", Error = "✕"}
        
        local Notif = Create("Frame", {
            Parent = NotifContainer,
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(1, 0, 0, 70),
            Position = UDim2.new(1, 50, 0, 0),
            ClipsDescendants = true
        })
        Corner(Notif, 8)
        Stroke(Notif, colors[notifConfig.Type], 2)
        
        local Icon = Create("TextLabel", {
            Parent = Notif,
            BackgroundColor3 = colors[notifConfig.Type],
            Position = UDim2.new(0, 8, 0, 8),
            Size = UDim2.new(0, 28, 0, 28),
            Font = Enum.Font.GothamBold,
            Text = icons[notifConfig.Type],
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16
        })
        Corner(Icon, 6)
        
        Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 45, 0, 8),
            Size = UDim2.new(1, -55, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = notifConfig.Title,
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 45, 0, 30),
            Size = UDim2.new(1, -55, 0, 32),
            Font = Enum.Font.Gotham,
            Text = notifConfig.Text,
            TextColor3 = Theme.SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        local Progress = Create("Frame", {
            Parent = Notif,
            BackgroundColor3 = colors[notifConfig.Type],
            Position = UDim2.new(0, 0, 1, -3),
            Size = UDim2.new(1, 0, 0, 3)
        })
        
        Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, notifConfig.Duration)
        
        task.delay(notifConfig.Duration, function()
            Tween(Notif, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    -- CreateTab
    function Window:CreateTab(config)
        config = config or {}
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or nil
        }
        
        local Tab = {Name = tabConfig.Name, Elements = {}}
        
        local TabBtn = Create("TextButton", {
            Name = tabConfig.Name,
            Parent = TabScroll,
            BackgroundColor3 = Theme.Tab,
            Size = UDim2.new(0, tabConfig.Icon and 110 or 90, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "",
            AutoButtonColor = false
        })
        Corner(TabBtn, 6)
        
        if tabConfig.Icon then
            Create("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = tabConfig.Icon,
                ImageColor3 = Theme.Text
            })
        end
        
        Create("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, tabConfig.Icon and 32 or 10, 0, 0),
            Size = UDim2.new(1, tabConfig.Icon and -42 or -20, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = tabConfig.Name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local TabContent = Create("ScrollingFrame", {
            Name = tabConfig.Name .. "_Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
        
        Create("UIListLayout", {Parent = TabContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
        Create("UIPadding", {Parent = TabContent, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)})
        
        Tab.Button = TabBtn
        Tab.Content = TabContent
        
        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Theme.Tab}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.TabActive}, 0.2)
            Window.CurrentTab = Tab
        end
        
        TabBtn.MouseButton1Click:Connect(SelectTab)
        TabBtn.MouseEnter:Connect(function() if Window.CurrentTab ~= Tab then Tween(TabBtn, {BackgroundColor3 = Theme.ElementHover}, 0.15) end end)
        TabBtn.MouseLeave:Connect(function() if Window.CurrentTab ~= Tab then Tween(TabBtn, {BackgroundColor3 = Theme.Tab}, 0.15) end end)
        
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then SelectTab() end
        
        -- Section
        function Tab:CreateSection(name)
            local Section = Create("Frame", {Parent = TabContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25)})
            Create("TextLabel", {Parent = Section, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold, Text = name, TextColor3 = Theme.SubText, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left})
        end
        
        -- Button
        function Tab:CreateButton(config)
            config = config or {}
            local btnConfig = {Name = config.Name or "Button", Description = config.Description, Callback = config.Callback or function() end}
            local hasDesc = btnConfig.Description ~= nil
            local height = hasDesc and 50 or 36
            
            local Button = Create("TextButton", {Parent = TabContent, BackgroundColor3 = Theme.Element, Size = UDim2.new(1, 0, 0, height), Text = "", AutoButtonColor = false})
            Corner(Button, 6)
            Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0), Size = UDim2.new(1, -50, 0, hasDesc and 18 or height), Font = Enum.Font.GothamBold, Text = btnConfig.Name, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
            if hasDesc then Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24), Size = UDim2.new(1, -50, 0, 18), Font = Enum.Font.Gotham, Text = btnConfig.Description, TextColor3 = Theme.SubText, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left}) end
            Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(1, -35, 0, 0), Size = UDim2.new(0, 25, 1, 0), Font = Enum.Font.GothamBold, Text = "→", TextColor3 = Theme.Accent, TextSize = 16})
            
            Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = Theme.ElementHover}, 0.15) end)
            Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = Theme.Element}, 0.15) end)
            Button.MouseButton1Click:Connect(function() btnConfig.Callback() end)
            
            return {SetText = function(self, text) Button:FindFirstChildOfClass("TextLabel").Text = text end}
        end
        
        -- Toggle
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleConfig = {Name = config.Name or "Toggle", Description = config.Description, CurrentValue = config.CurrentValue or false, Callback = config.Callback or function() end}
            local Enabled = toggleConfig.CurrentValue
            local hasDesc = toggleConfig.Description ~= nil
            local height = hasDesc and 50 or 36
            
            local Toggle = Create("TextButton", {Parent = TabContent, BackgroundColor3 = Theme.Element, Size = UDim2.new(1, 0, 0, height), Text = "", AutoButtonColor = false})
            Corner(Toggle, 6)
            Create("TextLabel", {Parent = Toggle, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0), Size = UDim2.new(1, -70, 0, hasDesc and 18 or height), Font = Enum.Font.GothamBold, Text = toggleConfig.Name, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
            if hasDesc then Create("TextLabel", {Parent = Toggle, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 24), Size = UDim2.new(1, -70, 0, 18), Font = Enum.Font.Gotham, Text = toggleConfig.Description, TextColor3 = Theme.SubText, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left}) end
            
            local Indicator = Create("Frame", {Parent = Toggle, BackgroundColor3 = Enabled and Theme.ToggleEnabled or Theme.Toggle, Position = UDim2.new(1, -52, 0.5, -10), Size = UDim2.new(0, 40, 0, 20)})
            Corner(Indicator, 10)
            local Circle = Create("Frame", {Parent = Indicator, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Size = UDim2.new(0, 16, 0, 16)})
            Corner(Circle, 8)
            
            local function UpdateToggle()
                Tween(Indicator, {BackgroundColor3 = Enabled and Theme.ToggleEnabled or Theme.Toggle}, 0.2)
                Tween(Circle, {Position = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
            end
            
            Toggle.MouseButton1Click:Connect(function() Enabled = not Enabled UpdateToggle() toggleConfig.Callback(Enabled) end)
            Toggle.MouseEnter:Connect(function() Tween(Toggle, {BackgroundColor3 = Theme.ElementHover}, 0.15) end)
            Toggle.MouseLeave:Connect(function() Tween(Toggle, {BackgroundColor3 = Theme.Element}, 0.15) end)
            
            return {Set = function(self, v) Enabled = v UpdateToggle() toggleConfig.Callback(Enabled) end, Get = function() return Enabled end}
        end
        
        -- Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderConfig = {Name = config.Name or "Slider", Description = config.Description, Min = config.Min or 0, Max = config.Max or 100, CurrentValue = config.CurrentValue or 50, Increment = config.Increment or 1, Callback = config.Callback or function() end}
            local Value = sliderConfig.CurrentValue
            local hasDesc = sliderConfig.Description ~= nil
            local height = hasDesc and 65 or 50
            
            local Slider = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Element, Size = UDim2.new(1, 0, 0, height)})
            Corner(Slider, 6)
            Create("TextLabel", {Parent = Slider, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, hasDesc and 6 or 4), Size = UDim2.new(1, -70, 0, 16), Font = Enum.Font.GothamBold, Text = sliderConfig.Name, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
            local ValueLabel = Create("TextLabel", {Parent = Slider, BackgroundTransparency = 1, Position = UDim2.new(1, -55, 0, hasDesc and 6 or 4), Size = UDim2.new(0, 45, 0, 16), Font = Enum.Font.GothamBold, Text = tostring(Value), TextColor3 = Theme.Accent, TextSize = 13})
            if hasDesc then Create("TextLabel", {Parent = Slider, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 22), Size = UDim2.new(1, -24, 0, 14), Font = Enum.Font.Gotham, Text = sliderConfig.Description, TextColor3 = Theme.SubText, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left}) end
            
            local SliderBar = Create("Frame", {Parent = Slider, BackgroundColor3 = Theme.Toggle, Position = UDim2.new(0, 12, 1, -18), Size = UDim2.new(1, -24, 0, 6)})
            Corner(SliderBar, 3)
            local fillPercent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
            local SliderFill = Create("Frame", {Parent = SliderBar, BackgroundColor3 = Theme.Accent, Size = UDim2.new(fillPercent, 0, 1, 0)})
            Corner(SliderFill, 3)
            local Knob = Create("Frame", {Parent = SliderBar, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(fillPercent, -8, 0.5, -8), Size = UDim2.new(0, 16, 0, 16)})
            Corner(Knob, 8)
            local SliderBtn = Create("TextButton", {Parent = SliderBar, BackgroundTransparency = 1, Size = UDim2.new(1, 20, 1, 20), Position = UDim2.new(0, -10, 0, -10), Text = ""})
            
            local sDragging = false
            local function UpdateSlider(input)
                local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = math.floor((sliderConfig.Min + percent * (sliderConfig.Max - sliderConfig.Min)) / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                Value = math.clamp(Value, sliderConfig.Min, sliderConfig.Max)
                local newPercent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                SliderFill.Size = UDim2.new(newPercent, 0, 1, 0)
                Knob.Position = UDim2.new(newPercent, -8, 0.5, -8)
                ValueLabel.Text = tostring(Value)
                sliderConfig.Callback(Value)
            end
            
            SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sDragging = true UpdateSlider(input) end end)
            SliderBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sDragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end end)
            
            return {Set = function(self, v) Value = math.clamp(v, sliderConfig.Min, sliderConfig.Max) local p = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min) SliderFill.Size = UDim2.new(p, 0, 1, 0) Knob.Position = UDim2.new(p, -8, 0.5, -8) ValueLabel.Text = tostring(Value) sliderConfig.Callback(Value) end, Get = function() return Value end}
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local Label = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Element, Size = UDim2.new(1, 0, 0, 32)})
            Corner(Label, 6)
            local LabelText = Create("TextLabel", {Parent = Label, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -24, 1, 0), Font = Enum.Font.Gotham, Text = text, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
            return {Set = function(self, t) LabelText.Text = t end}
        end
        
        return Tab
    end
    
    self.Window = Window
    return Window
end

return MinrLib
