--[[
    MinrLib - UI Library
    Roblox Executor UI Library
]]

local MinrLib = {}

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Безопасный Parent
local GuiParent
pcall(function()
    local test = Instance.new("ScreenGui")
    test.Parent = game:GetService("CoreGui")
    test:Destroy()
    GuiParent = game:GetService("CoreGui")
end)
if not GuiParent then
    GuiParent = Player:WaitForChild("PlayerGui")
end

-- Темы
MinrLib.Themes = {
    Default = {
        Main = Color3.fromRGB(136, 136, 136),
        MainTransparency = 0.4,
        TopBar = Color3.fromRGB(67, 67, 67),
        TabBar = Color3.fromRGB(99, 99, 99),
        Tab = Color3.fromRGB(75, 75, 75),
        TabActive = Color3.fromRGB(100, 130, 255),
        Button = Color3.fromRGB(100, 100, 100),
        ButtonHover = Color3.fromRGB(120, 120, 120),
        CloseBtn = Color3.fromRGB(146, 146, 150),
        Toggle = Color3.fromRGB(80, 80, 80),
        ToggleEnabled = Color3.fromRGB(100, 200, 130),
        Accent = Color3.fromRGB(100, 130, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200),
        Alert = Color3.fromRGB(67, 67, 67),
        AlertHeader = Color3.fromRGB(63, 63, 63)
    },
    Dark = {
        Main = Color3.fromRGB(30, 30, 35),
        MainTransparency = 0.1,
        TopBar = Color3.fromRGB(20, 20, 25),
        TabBar = Color3.fromRGB(25, 25, 30),
        Tab = Color3.fromRGB(40, 40, 45),
        TabActive = Color3.fromRGB(80, 100, 220),
        Button = Color3.fromRGB(45, 45, 50),
        ButtonHover = Color3.fromRGB(55, 55, 60),
        CloseBtn = Color3.fromRGB(60, 60, 65),
        Toggle = Color3.fromRGB(50, 50, 55),
        ToggleEnabled = Color3.fromRGB(80, 170, 120),
        Accent = Color3.fromRGB(80, 100, 220),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(170, 170, 180),
        Alert = Color3.fromRGB(25, 25, 30),
        AlertHeader = Color3.fromRGB(20, 20, 25)
    },
    Ocean = {
        Main = Color3.fromRGB(25, 45, 65),
        MainTransparency = 0.2,
        TopBar = Color3.fromRGB(15, 35, 55),
        TabBar = Color3.fromRGB(20, 40, 60),
        Tab = Color3.fromRGB(35, 55, 75),
        TabActive = Color3.fromRGB(0, 150, 200),
        Button = Color3.fromRGB(40, 60, 80),
        ButtonHover = Color3.fromRGB(50, 70, 90),
        CloseBtn = Color3.fromRGB(50, 70, 90),
        Toggle = Color3.fromRGB(40, 60, 80),
        ToggleEnabled = Color3.fromRGB(0, 150, 200),
        Accent = Color3.fromRGB(0, 150, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 200, 220),
        Alert = Color3.fromRGB(20, 40, 60),
        AlertHeader = Color3.fromRGB(15, 35, 55)
    },
    Purple = {
        Main = Color3.fromRGB(45, 35, 65),
        MainTransparency = 0.2,
        TopBar = Color3.fromRGB(35, 25, 55),
        TabBar = Color3.fromRGB(40, 30, 60),
        Tab = Color3.fromRGB(55, 45, 75),
        TabActive = Color3.fromRGB(140, 90, 200),
        Button = Color3.fromRGB(60, 50, 80),
        ButtonHover = Color3.fromRGB(70, 60, 90),
        CloseBtn = Color3.fromRGB(70, 60, 90),
        Toggle = Color3.fromRGB(60, 50, 80),
        ToggleEnabled = Color3.fromRGB(140, 90, 200),
        Accent = Color3.fromRGB(140, 90, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 180, 220),
        Alert = Color3.fromRGB(40, 30, 60),
        AlertHeader = Color3.fromRGB(35, 25, 55)
    },
        -- НОВАЯ ТЕМА ДЛЯ SHOOTER СКРИПТА
    Shooter = {
        Main = Color3.fromRGB(15, 15, 20),
        MainTransparency = 0.05,
        TopBar = Color3.fromRGB(20, 20, 28),
        TabBar = Color3.fromRGB(18, 18, 25),
        Tab = Color3.fromRGB(30, 30, 40),
        TabActive = Color3.fromRGB(138, 43, 226), -- Purple accent
        Button = Color3.fromRGB(35, 35, 45),
        ButtonHover = Color3.fromRGB(45, 45, 58),
        CloseBtn = Color3.fromRGB(40, 40, 50),
        Toggle = Color3.fromRGB(40, 40, 50),
        ToggleEnabled = Color3.fromRGB(138, 43, 226), -- Purple
        Accent = Color3.fromRGB(138, 43, 226), -- Purple
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 175),
        Alert = Color3.fromRGB(20, 20, 28),
        AlertHeader = Color3.fromRGB(15, 15, 22)
    },
    
    -- Красная тема (агрессивная)
    Red = {
        Main = Color3.fromRGB(20, 12, 12),
        MainTransparency = 0.05,
        TopBar = Color3.fromRGB(28, 15, 15),
        TabBar = Color3.fromRGB(25, 13, 13),
        Tab = Color3.fromRGB(40, 25, 25),
        TabActive = Color3.fromRGB(200, 50, 50),
        Button = Color3.fromRGB(45, 28, 28),
        ButtonHover = Color3.fromRGB(58, 35, 35),
        CloseBtn = Color3.fromRGB(50, 30, 30),
        Toggle = Color3.fromRGB(50, 30, 30),
        ToggleEnabled = Color3.fromRGB(200, 50, 50),
        Accent = Color3.fromRGB(200, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 160, 160),
        Alert = Color3.fromRGB(28, 15, 15),
        AlertHeader = Color3.fromRGB(22, 12, 12)
    },
    
    -- Зелёная тема (Matrix style)
    Matrix = {
        Main = Color3.fromRGB(8, 18, 12),
        MainTransparency = 0.05,
        TopBar = Color3.fromRGB(10, 25, 15),
        TabBar = Color3.fromRGB(9, 22, 13),
        Tab = Color3.fromRGB(15, 35, 22),
        TabActive = Color3.fromRGB(0, 200, 80),
        Button = Color3.fromRGB(18, 42, 28),
        ButtonHover = Color3.fromRGB(25, 55, 35),
        CloseBtn = Color3.fromRGB(20, 45, 30),
        Toggle = Color3.fromRGB(20, 45, 30),
        ToggleEnabled = Color3.fromRGB(0, 200, 80),
        Accent = Color3.fromRGB(0, 200, 80),
        Text = Color3.fromRGB(220, 255, 230),
        SubText = Color3.fromRGB(140, 200, 160),
        Alert = Color3.fromRGB(10, 25, 15),
        AlertHeader = Color3.fromRGB(8, 20, 12)
    }
}

-- Утилиты
local function Tween(obj, props, duration, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
        props
    )
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
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function Stroke(parent, color, thickness)
    return Create("UIStroke", {Color = color or Color3.fromRGB(60, 60, 65), Thickness = thickness or 1, Parent = parent})
end

--[[
    СОЗДАНИЕ ОКНА
]]
function MinrLib:CreateWindow(config)
    config = config or {}
    
    local WindowConfig = {
        Name = config.Name or "GUI NAME",
        Theme = config.Theme or "Default",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
        KeySystem = config.KeySystem or false,
        Key = config.Key or {""},
        KeyTitle = config.KeyTitle or "Key System",
        KeyDescription = config.KeyDescription or "Enter the key"
    }
    
    local Theme = self.Themes[WindowConfig.Theme] or self.Themes.Default
    
    -- Key System
    if WindowConfig.KeySystem then
        local keyCorrect = false
        
        local KeyGui = Create("ScreenGui", {Name = "MinrLib_Key", Parent = GuiParent, ResetOnSpawn = false})
        
        local KeyFrame = Create("Frame", {
            Parent = KeyGui,
            BackgroundColor3 = Theme.Main,
            BackgroundTransparency = Theme.MainTransparency,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 300, 0, 180)
        })
        Corner(KeyFrame, 8)
        
        local KeyTop = Create("Frame", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.TopBar,
            Size = UDim2.new(1, 0, 0, 40)
        })
        Corner(KeyTop, 8)
        
        Create("TextLabel", {
            Parent = KeyTop,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = WindowConfig.KeyTitle,
            TextColor3 = Theme.Text,
            TextSize = 16
        })
        
        Create("TextLabel", {
            Parent = KeyFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 50),
            Size = UDim2.new(1, -30, 0, 25),
            Font = Enum.Font.Gotham,
            Text = WindowConfig.KeyDescription,
            TextColor3 = Theme.SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local KeyInput = Create("TextBox", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.Button,
            Position = UDim2.new(0, 15, 0, 85),
            Size = UDim2.new(1, -30, 0, 35),
            Font = Enum.Font.Gotham,
            PlaceholderText = "Enter key...",
            Text = "",
            TextColor3 = Theme.Text,
            PlaceholderColor3 = Theme.SubText,
            TextSize = 14
        })
        Corner(KeyInput, 6)
        
        local KeySubmit = Create("TextButton", {
            Parent = KeyFrame,
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 15, 0, 130),
            Size = UDim2.new(1, -30, 0, 35),
            Font = Enum.Font.GothamBold,
            Text = "Submit",
            TextColor3 = Theme.Text,
            TextSize = 14
        })
        Corner(KeySubmit, 6)
        
        local function CheckKey()
            for _, key in pairs(WindowConfig.Key) do
                if KeyInput.Text == key then
                    keyCorrect = true
                    break
                end
            end
            
            if keyCorrect then
                Tween(KeyFrame, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                KeyGui:Destroy()
            else
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Wrong key!"
                Tween(KeyInput, {Position = UDim2.new(0, 5, 0, 85)}, 0.05)
                task.wait(0.05)
                Tween(KeyInput, {Position = UDim2.new(0, 25, 0, 85)}, 0.05)
                task.wait(0.05)
                Tween(KeyInput, {Position = UDim2.new(0, 15, 0, 85)}, 0.05)
            end
        end
        
        KeySubmit.MouseButton1Click:Connect(CheckKey)
        KeyInput.FocusLost:Connect(function(enter) if enter then CheckKey() end end)
        
        repeat task.wait() until keyCorrect
    end
    
    -- Главный ScreenGui
    local MinrGUI = Create("ScreenGui", {
        Name = "MinrLib_" .. WindowConfig.Name,
        Parent = GuiParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Константы размеров
    local TOPBAR_HEIGHT = 53
    local MAIN_HEIGHT = 381
    
    -- TopBar (shapk) - AnchorPoint снизу чтобы main прилегал
    local shapk = Create("Frame", {
        Name = "shapk",
        Parent = MinrGUI,
        BackgroundColor3 = Theme.TopBar,
        AnchorPoint = Vector2.new(0.5, 1), -- Привязка снизу
        Position = UDim2.new(0.5, 0, 0.5, -MAIN_HEIGHT/2), -- Позиция так чтобы низ shapk был над main
        Size = IsMobile and UDim2.new(0.95, 0, 0, TOPBAR_HEIGHT) or UDim2.new(0, 547, 0, TOPBAR_HEIGHT),
        ClipsDescendants = true
    })
    Corner(shapk, 8)
    
    Create("UISizeConstraint", {Parent = shapk, MinSize = Vector2.new(350, TOPBAR_HEIGHT), MaxSize = Vector2.new(700, TOPBAR_HEIGHT)})
    
    -- Название GUI
    local textshapk = Create("Frame", {
        Parent = shapk,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -100, 0, 0),
        Size = UDim2.new(0, 200, 1, 0)
    })
    
    Create("TextLabel", {
        Parent = textshapk,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowConfig.Name,
        TextColor3 = Theme.Text,
        TextSize = 20
    })
    
    -- Кнопка X (скрытие)
    local X = Create("TextButton", {
        Name = "X",
        Parent = shapk,
        BackgroundColor3 = Color3.fromRGB(220, 80, 80),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 37, 0, 36),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 20,
        AutoButtonColor = false
    })
    Corner(X, 6)
    
    -- Кнопка - (сворачивание)
    local MinBtn = Create("TextButton", {
        Name = "Minimize",
        Parent = shapk,
        BackgroundColor3 = Color3.fromRGB(220, 180, 80),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -55, 0.5, 0),
        Size = UDim2.new(0, 37, 0, 36),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Theme.Text,
        TextSize = 20,
        AutoButtonColor = false
    })
    Corner(MinBtn, 6)
    
    -- Main Frame - AnchorPoint сверху, позиция точно под shapk
    local main = Create("Frame", {
        Name = "main",
        Parent = MinrGUI,
        BackgroundColor3 = Theme.Main,
        BackgroundTransparency = Theme.MainTransparency,
        AnchorPoint = Vector2.new(0.5, 0), -- Привязка сверху
        Position = UDim2.new(0.5, 0, 0.5, -MAIN_HEIGHT/2), -- Точно под shapk (там где низ shapk)
        Size = IsMobile and UDim2.new(0.95, 0, 0, MAIN_HEIGHT) or UDim2.new(0, 547, 0, MAIN_HEIGHT),
        ClipsDescendants = true
    })
    Corner(main, 8)
    
    Create("UISizeConstraint", {Parent = main, MinSize = Vector2.new(350, 0), MaxSize = Vector2.new(700, 500)})
    
    -- Tab Bar (shapk2)
    local shapk2 = Create("Frame", {
        Name = "shapk2",
        Parent = main,
        BackgroundColor3 = Theme.TabBar,
        BackgroundTransparency = 0.05,
        Size = UDim2.new(1, 0, 0, 64)
    })
    Corner(shapk2, 8)
    
    -- Tab ScrollFrame
    local TabScroll = Create("ScrollingFrame", {
        Parent = shapk2,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 12),
        Size = UDim2.new(1, -20, 0, 40),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    Create("UIListLayout", {
        Parent = TabScroll,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 64),
        Size = UDim2.new(1, 0, 1, -64)
    })
    
    -- Notification Container
    local NotifContainer = Create("Frame", {
        Name = "Notifications",
        Parent = MinrGUI,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -15, 1, -15),
        Size = UDim2.new(0, 352, 0, 400)
    })
    
    Create("UIListLayout", {
        Parent = NotifContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 10)
    })
    
    -- Mobile Button
    local MobileBtn
    if IsMobile then
        MobileBtn = Create("TextButton", {
            Parent = MinrGUI,
            BackgroundColor3 = Theme.Accent,
            Position = UDim2.new(0, 15, 0.5, -25),
            Size = UDim2.new(0, 50, 0, 50),
            Font = Enum.Font.GothamBold,
            Text = "☰",
            TextColor3 = Theme.Text,
            TextSize = 22,
            Visible = false
        })
        Corner(MobileBtn, 25)
    end
    
    -- Window Object
    local Window = {
        Gui = MinrGUI,
        Main = main,
        TopBar = shapk,
        TabScroll = TabScroll,
        ContentContainer = ContentContainer,
        NotifContainer = NotifContainer,
        Theme = Theme,
        Tabs = {},
        CurrentTab = nil,
        Minimized = false,
        Visible = true,
        ToggleKey = WindowConfig.ToggleKey
    }
    
    --[[
        УВЕДОМЛЕНИЯ
    ]]
    function Window:Notify(config)
        config = config or {}
        local notifConfig = {
            Title = config.Title or "Notification",
            Description = config.Description or "",
            Duration = config.Duration or 5,
            Type = config.Type or "Info",
            Icon = config.Icon or nil,
            Callback = config.Callback or nil
        }
        
        local colors = {
            Info = Theme.Accent,
            Success = Color3.fromRGB(80, 200, 120),
            Warning = Color3.fromRGB(220, 180, 80),
            Error = Color3.fromRGB(220, 80, 80)
        }
        
        local icons = {
            Info = "rbxassetid://7072717857",
            Success = "rbxassetid://7072718399",
            Warning = "rbxassetid://7072725342",
            Error = "rbxassetid://7072725623"
        }
        
        local Alert0 = Create("Frame", {
            Parent = NotifContainer,
            BackgroundColor3 = Theme.Alert,
            Size = UDim2.new(1, 0, 0, 109),
            Position = UDim2.new(1, 50, 0, 0),
            ClipsDescendants = true
        })
        Corner(Alert0, 8)
        Stroke(Alert0, colors[notifConfig.Type], 2)
        
        local alertShapk = Create("Frame", {
            Parent = Alert0,
            BackgroundColor3 = Theme.AlertHeader,
            Size = UDim2.new(1, 0, 0, 39)
        })
        Corner(alertShapk, 8)
        
        local SVGICON = Create("ImageLabel", {
            Parent = alertShapk,
            BackgroundColor3 = colors[notifConfig.Type],
            Position = UDim2.new(0, 5, 0.5, -17),
            Size = UDim2.new(0, 34, 0, 34),
            Image = notifConfig.Icon or icons[notifConfig.Type]
        })
        Corner(SVGICON, 6)
        
        Create("TextLabel", {
            Parent = alertShapk,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 50, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = notifConfig.Title,
            TextColor3 = Theme.Text,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        Create("TextLabel", {
            Parent = Alert0,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 45),
            Size = UDim2.new(1, -30, 0, 55),
            Font = Enum.Font.Gotham,
            Text = notifConfig.Description,
            TextColor3 = Theme.SubText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true
        })
        
        local Progress = Create("Frame", {
            Parent = Alert0,
            BackgroundColor3 = colors[notifConfig.Type],
            Position = UDim2.new(0, 0, 1, -4),
            Size = UDim2.new(1, 0, 0, 4)
        })
        
        Tween(Alert0, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        Tween(Progress, {Size = UDim2.new(0, 0, 0, 4)}, notifConfig.Duration)
        
        if notifConfig.Callback then
            notifConfig.Callback()
        end
        
        task.delay(notifConfig.Duration, function()
            Tween(Alert0, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
            task.wait(0.3)
            Alert0:Destroy()
        end)
    end
    
    -- Анимация появления
    local startShapkPos = shapk.Position
    local startMainPos = main.Position
    
    shapk.Position = UDim2.new(0.5, 0, 0, -100)
    main.Size = IsMobile and UDim2.new(0.95, 0, 0, 0) or UDim2.new(0, 547, 0, 0)
    shapk.BackgroundTransparency = 1
    main.BackgroundTransparency = 1
    
    task.spawn(function()
        task.wait(0.1)
        Tween(shapk, {Position = startShapkPos, BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back)
        task.wait(0.2)
        Tween(main, {Size = IsMobile and UDim2.new(0.95, 0, 0, MAIN_HEIGHT) or UDim2.new(0, 547, 0, MAIN_HEIGHT), BackgroundTransparency = Theme.MainTransparency}, 0.4, Enum.EasingStyle.Back)
        
        task.wait(0.5)
        if not IsMobile then
            Window:Notify({
                Title = "GUI Loaded",
                Description = "Press " .. WindowConfig.ToggleKey.Name .. " to toggle",
                Duration = 4,
                Type = "Info"
            })
        end
    end)
    
    -- Drag - синхронизированный
    local dragging, dragInput, dragStart, startPosShapk
    
    shapk.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosShapk = shapk.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    shapk.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            -- Новая позиция shapk (низ shapk)
            local newShapkPos = UDim2.new(
                startPosShapk.X.Scale, 
                startPosShapk.X.Offset + delta.X, 
                startPosShapk.Y.Scale, 
                startPosShapk.Y.Offset + delta.Y
            )
            shapk.Position = newShapkPos
            
            -- main следует точно: его верх = низ shapk (та же Y позиция, т.к. shapk AnchorPoint снизу, main сверху)
            main.Position = UDim2.new(
                newShapkPos.X.Scale, 
                newShapkPos.X.Offset, 
                newShapkPos.Y.Scale, 
                newShapkPos.Y.Offset
            )
        end
    end)
    
    --[[
        КНОПКА X - СКРЫТИЕ GUI
    ]]
    X.MouseButton1Click:Connect(function()
        Window.Visible = false
        
        Tween(shapk, {BackgroundTransparency = 1}, 0.3)
        Tween(main, {Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 0)}, 0.3)
        
        task.wait(0.3)
        shapk.Visible = false
        main.Visible = false
        
        if MobileBtn then
            MobileBtn.Visible = true
        end
        
        if not IsMobile then
            Window:Notify({
                Title = "GUI Hidden",
                Description = "Press " .. WindowConfig.ToggleKey.Name .. " to open GUI",
                Duration = 5,
                Type = "Info"
            })
        else
            Window:Notify({
                Title = "GUI Hidden",
                Description = "Tap the ☰ button to open GUI",
                Duration = 5,
                Type = "Info"
            })
        end
    end)
    
    X.MouseEnter:Connect(function() Tween(X, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.15) end)
    X.MouseLeave:Connect(function() Tween(X, {BackgroundColor3 = Color3.fromRGB(220, 80, 80)}, 0.15) end)
    
    --[[
        КНОПКА MINIMIZE - СВОРАЧИВАНИЕ
    ]]
    MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        
        if Window.Minimized then
            Tween(main, {Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 0)}, 0.3, Enum.EasingStyle.Quart)
            MinBtn.Text = "+"
        else
            Tween(main, {Size = IsMobile and UDim2.new(0.95, 0, 0, MAIN_HEIGHT) or UDim2.new(0, 547, 0, MAIN_HEIGHT)}, 0.3, Enum.EasingStyle.Quart)
            MinBtn.Text = "−"
        end
    end)
    
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Color3.fromRGB(255, 200, 100)}, 0.15) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Color3.fromRGB(220, 180, 80)}, 0.15) end)
    
    --[[
        TOGGLE KEY
    ]]
    if not IsMobile then
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == WindowConfig.ToggleKey then
                Window.Visible = not Window.Visible
                
                if Window.Visible then
                    shapk.Visible = true
                    shapk.BackgroundTransparency = 0
                    
                    if not Window.Minimized then
                        main.Visible = true
                        main.Size = IsMobile and UDim2.new(0.95, 0, 0, MAIN_HEIGHT) or UDim2.new(0, 547, 0, MAIN_HEIGHT)
                    end
                    
                    if MobileBtn then
                        MobileBtn.Visible = false
                    end
                else
                    shapk.Visible = false
                    main.Visible = false
                    
                    if MobileBtn then
                        MobileBtn.Visible = true
                    end
                end
            end
        end)
    end
    
    --[[
        МОБИЛЬНАЯ КНОПКА
    ]]
    if MobileBtn then
        local mDragging = false
        local mDragStart, mStartPos
        
        MobileBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                mDragging = true
                mDragStart = input.Position
                mStartPos = MobileBtn.Position
            end
        end)
        
        MobileBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                mDragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if mDragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - mDragStart
                MobileBtn.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + delta.X, mStartPos.Y.Scale, mStartPos.Y.Offset + delta.Y)
            end
        end)
        
        MobileBtn.MouseButton1Click:Connect(function()
            Window.Visible = true
            shapk.Visible = true
            shapk.BackgroundTransparency = 0
            main.Visible = true
            MobileBtn.Visible = false
            
            if Window.Minimized then
                Window.Minimized = false
                main.Size = IsMobile and UDim2.new(0.95, 0, 0, MAIN_HEIGHT) or UDim2.new(0, 547, 0, MAIN_HEIGHT)
                MinBtn.Text = "−"
            else
                main.Size = IsMobile and UDim2.new(0.95, 0, 0, MAIN_HEIGHT) or UDim2.new(0, 547, 0, MAIN_HEIGHT)
            end
        end)
    end
    
    --[[
        СОЗДАНИЕ ТАБА
    ]]
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
            Size = UDim2.new(0, 93, 0, 40),
            Font = Enum.Font.GothamBold,
            Text = "",
            AutoButtonColor = false
        })
        Corner(TabBtn, 6)
        
        if tabConfig.Icon then
            Create("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = tabConfig.Icon,
                ImageColor3 = Theme.Text
            })
            
            Create("TextLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 32, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = tabConfig.Name,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        else
            Create("TextLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = tabConfig.Name,
                TextColor3 = Theme.Text,
                TextSize = 13
            })
        end
        
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
        
        Create("UIListLayout", {Parent = TabContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = TabContent, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        
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
        TabBtn.MouseEnter:Connect(function() if Window.CurrentTab ~= Tab then Tween(TabBtn, {BackgroundColor3 = Theme.ButtonHover}, 0.15) end end)
        TabBtn.MouseLeave:Connect(function() if Window.CurrentTab ~= Tab then Tween(TabBtn, {BackgroundColor3 = Theme.Tab}, 0.15) end end)
        
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then SelectTab() end
        
        -- Section
        function Tab:CreateSection(name)
            local Section = Create("Frame", {Parent = TabContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25)})
            Create("TextLabel", {Parent = Section, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold, Text = name, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            Create("Frame", {Parent = Section, BackgroundColor3 = Theme.SubText, BackgroundTransparency = 0.5, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1)})
        end
        
        -- Button
        function Tab:CreateButton(config)
            config = config or {}
            local btnConfig = {Name = config.Name or "Button", Description = config.Description, Callback = config.Callback or function() end}
            local height = btnConfig.Description and 55 or 38
            
            local Button = Create("TextButton", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, height), Text = "", AutoButtonColor = false})
            Corner(Button, 6)
            
            Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, btnConfig.Description and 8 or 0), Size = UDim2.new(1, -30, 0, btnConfig.Description and 20 or height), Font = Enum.Font.GothamBold, Text = btnConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            if btnConfig.Description then
                Create("TextLabel", {Parent = Button, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 28), Size = UDim2.new(1, -30, 0, 20), Font = Enum.Font.Gotham, Text = btnConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = Theme.ButtonHover}, 0.15) end)
            Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = Theme.Button}, 0.15) end)
            Button.MouseButton1Click:Connect(function() btnConfig.Callback() end)
            
            return {SetText = function(_, t) Button:FindFirstChildOfClass("TextLabel").Text = t end}
        end
        
        -- Toggle
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleConfig = {Name = config.Name or "Toggle", Description = config.Description, CurrentValue = config.CurrentValue or false, Callback = config.Callback or function() end}
            local Enabled = toggleConfig.CurrentValue
            local height = toggleConfig.Description and 55 or 38
            
            local Toggle = Create("TextButton", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, height), Text = "", AutoButtonColor = false})
            Corner(Toggle, 6)
            
            Create("TextLabel", {Parent = Toggle, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, toggleConfig.Description and 8 or 0), Size = UDim2.new(1, -80, 0, toggleConfig.Description and 20 or height), Font = Enum.Font.GothamBold, Text = toggleConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            if toggleConfig.Description then
                Create("TextLabel", {Parent = Toggle, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 28), Size = UDim2.new(1, -80, 0, 20), Font = Enum.Font.Gotham, Text = toggleConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            local Indicator = Create("Frame", {Parent = Toggle, BackgroundColor3 = Enabled and Theme.ToggleEnabled or Theme.Toggle, Position = UDim2.new(1, -60, 0.5, -12), Size = UDim2.new(0, 48, 0, 24)})
            Corner(Indicator, 12)
            
            local Circle = Create("Frame", {Parent = Indicator, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = Enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), Size = UDim2.new(0, 20, 0, 20)})
            Corner(Circle, 10)
            
            local function Update()
                Tween(Indicator, {BackgroundColor3 = Enabled and Theme.ToggleEnabled or Theme.Toggle}, 0.2)
                Tween(Circle, {Position = Enabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
            end
            
            Toggle.MouseButton1Click:Connect(function() Enabled = not Enabled Update() toggleConfig.Callback(Enabled) end)
            Toggle.MouseEnter:Connect(function() Tween(Toggle, {BackgroundColor3 = Theme.ButtonHover}, 0.15) end)
            Toggle.MouseLeave:Connect(function() Tween(Toggle, {BackgroundColor3 = Theme.Button}, 0.15) end)
            
            return {Set = function(_, v) Enabled = v Update() toggleConfig.Callback(Enabled) end, Get = function() return Enabled end}
        end
        
        -- Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderConfig = {Name = config.Name or "Slider", Description = config.Description, Min = config.Min or 0, Max = config.Max or 100, CurrentValue = config.CurrentValue or 50, Increment = config.Increment or 1, Callback = config.Callback or function() end}
            local Value = sliderConfig.CurrentValue
            local height = sliderConfig.Description and 70 or 55
            
            local Slider = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, height)})
            Corner(Slider, 6)
            
            Create("TextLabel", {Parent = Slider, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 8), Size = UDim2.new(1, -80, 0, 18), Font = Enum.Font.GothamBold, Text = sliderConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            local ValueLabel = Create("TextLabel", {Parent = Slider, BackgroundTransparency = 1, Position = UDim2.new(1, -65, 0, 8), Size = UDim2.new(0, 50, 0, 18), Font = Enum.Font.GothamBold, Text = tostring(Value), TextColor3 = Theme.Accent, TextSize = 14})
            
            if sliderConfig.Description then
                Create("TextLabel", {Parent = Slider, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 26), Size = UDim2.new(1, -30, 0, 16), Font = Enum.Font.Gotham, Text = sliderConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            local SliderBar = Create("Frame", {Parent = Slider, BackgroundColor3 = Theme.Toggle, Position = UDim2.new(0, 15, 1, -22), Size = UDim2.new(1, -30, 0, 8)})
            Corner(SliderBar, 4)
            
            local percent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
            local SliderFill = Create("Frame", {Parent = SliderBar, BackgroundColor3 = Theme.Accent, Size = UDim2.new(percent, 0, 1, 0)})
            Corner(SliderFill, 4)
            
            local Knob = Create("Frame", {Parent = SliderBar, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(percent, -10, 0.5, -10), Size = UDim2.new(0, 20, 0, 20)})
            Corner(Knob, 10)
            
            local SliderBtn = Create("TextButton", {Parent = SliderBar, BackgroundTransparency = 1, Size = UDim2.new(1, 20, 1, 20), Position = UDim2.new(0, -10, 0, -10), Text = ""})
            
            local sDragging = false
            local function UpdateSlider(input)
                local p = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Value = math.floor((sliderConfig.Min + p * (sliderConfig.Max - sliderConfig.Min)) / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                Value = math.clamp(Value, sliderConfig.Min, sliderConfig.Max)
                local np = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                SliderFill.Size = UDim2.new(np, 0, 1, 0)
                Knob.Position = UDim2.new(np, -10, 0.5, -10)
                ValueLabel.Text = tostring(Value)
                sliderConfig.Callback(Value)
            end
            
            SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sDragging = true UpdateSlider(input) end end)
            SliderBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sDragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end end)
            
            return {Set = function(_, v) Value = math.clamp(v, sliderConfig.Min, sliderConfig.Max) local p = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min) SliderFill.Size = UDim2.new(p, 0, 1, 0) Knob.Position = UDim2.new(p, -10, 0.5, -10) ValueLabel.Text = tostring(Value) sliderConfig.Callback(Value) end, Get = function() return Value end}
        end
        
        -- Dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            local dropConfig = {Name = config.Name or "Dropdown", Description = config.Description, Options = config.Options or {"Option 1", "Option 2"}, CurrentOption = config.CurrentOption, MultiSelect = config.MultiSelect or false, Callback = config.Callback or function() end}
            local Selected = dropConfig.MultiSelect and {} or (dropConfig.CurrentOption or dropConfig.Options[1])
            local Opened = false
            local baseHeight = dropConfig.Description and 55 or 38
            
            local Dropdown = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, baseHeight), ClipsDescendants = true})
            Corner(Dropdown, 6)
            
            local DropBtn = Create("TextButton", {Parent = Dropdown, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, baseHeight), Text = ""})
            
            Create("TextLabel", {Parent = DropBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, dropConfig.Description and 8 or 0), Size = UDim2.new(0.5, 0, 0, dropConfig.Description and 20 or baseHeight), Font = Enum.Font.GothamBold, Text = dropConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            local SelectedLabel = Create("TextLabel", {Parent = DropBtn, BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0, dropConfig.Description and 8 or 0), Size = UDim2.new(0.5, -40, 0, dropConfig.Description and 20 or baseHeight), Font = Enum.Font.Gotham, Text = dropConfig.MultiSelect and "None" or Selected, TextColor3 = Theme.SubText, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right})
            
            local Arrow = Create("TextLabel", {Parent = DropBtn, BackgroundTransparency = 1, Position = UDim2.new(1, -35, 0, 0), Size = UDim2.new(0, 25, 0, baseHeight), Font = Enum.Font.GothamBold, Text = "▼", TextColor3 = Theme.SubText, TextSize = 12})
            
            if dropConfig.Description then
                Create("TextLabel", {Parent = DropBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 28), Size = UDim2.new(1, -30, 0, 20), Font = Enum.Font.Gotham, Text = dropConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            local OptionsFrame = Create("Frame", {Parent = Dropdown, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, baseHeight + 5), Size = UDim2.new(1, -20, 0, 0)})
            Create("UIListLayout", {Parent = OptionsFrame, Padding = UDim.new(0, 5)})
            
            local function UpdateSelected()
                if dropConfig.MultiSelect then
                    SelectedLabel.Text = #Selected == 0 and "None" or (#Selected == 1 and Selected[1] or #Selected .. " selected")
                else
                    SelectedLabel.Text = Selected
                end
            end
            
            local function CreateOption(name)
                local Opt = Create("TextButton", {Parent = OptionsFrame, BackgroundColor3 = Theme.Toggle, Size = UDim2.new(1, 0, 0, 30), Font = Enum.Font.Gotham, Text = "  " .. name, TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false})
                Corner(Opt, 4)
                
                Opt.MouseButton1Click:Connect(function()
                    if dropConfig.MultiSelect then
                        local idx = table.find(Selected, name)
                        if idx then table.remove(Selected, idx) Tween(Opt, {BackgroundColor3 = Theme.Toggle}, 0.15)
                        else table.insert(Selected, name) Tween(Opt, {BackgroundColor3 = Theme.Accent}, 0.15) end
                        UpdateSelected()
                        dropConfig.Callback(Selected)
                    else
                        for _, o in pairs(OptionsFrame:GetChildren()) do if o:IsA("TextButton") then Tween(o, {BackgroundColor3 = Theme.Toggle}, 0.15) end end
                        Tween(Opt, {BackgroundColor3 = Theme.Accent}, 0.15)
                        Selected = name
                        UpdateSelected()
                        dropConfig.Callback(Selected)
                        Opened = false
                        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, baseHeight)}, 0.25)
                        Tween(Arrow, {Rotation = 0}, 0.25)
                    end
                end)
            end
            
            for _, opt in ipairs(dropConfig.Options) do CreateOption(opt) end
            
            DropBtn.MouseButton1Click:Connect(function()
                Opened = not Opened
                local h = Opened and (baseHeight + #dropConfig.Options * 35 + 10) or baseHeight
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, h)}, 0.25)
                Tween(Arrow, {Rotation = Opened and 180 or 0}, 0.25)
            end)
            
            local DropdownAPI = {}
            function DropdownAPI:Set(v)
                if dropConfig.MultiSelect then
                    Selected = type(v) == "table" and v or {v}
                else
                    Selected = v
                end
                UpdateSelected()
                dropConfig.Callback(Selected)
            end
            function DropdownAPI:Get()
                return Selected
            end
            function DropdownAPI:Refresh(newOptions)
                for _, child in pairs(OptionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                dropConfig.Options = newOptions
                for _, opt in ipairs(newOptions) do
                    CreateOption(opt)
                end
                if not dropConfig.MultiSelect then
                    Selected = newOptions[1] or ""
                    UpdateSelected()
                end
            end
            return DropdownAPI
        end
        
        -- Input
        function Tab:CreateInput(config)
            config = config or {}
            local inputConfig = {Name = config.Name or "Input", Description = config.Description, PlaceholderText = config.PlaceholderText or "Type here...", Callback = config.Callback or function() end}
            local height = inputConfig.Description and 75 or 60
            
            local Input = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, height)})
            Corner(Input, 6)
            
            Create("TextLabel", {Parent = Input, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 8), Size = UDim2.new(1, -30, 0, 18), Font = Enum.Font.GothamBold, Text = inputConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            if inputConfig.Description then
                Create("TextLabel", {Parent = Input, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 26), Size = UDim2.new(1, -30, 0, 16), Font = Enum.Font.Gotham, Text = inputConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            local TextBox = Create("TextBox", {Parent = Input, BackgroundColor3 = Theme.Toggle, Position = UDim2.new(0, 15, 1, -35), Size = UDim2.new(1, -30, 0, 28), Font = Enum.Font.Gotham, PlaceholderText = inputConfig.PlaceholderText, PlaceholderColor3 = Theme.SubText, Text = "", TextColor3 = Theme.Text, TextSize = 13})
            Corner(TextBox, 4)
            
            TextBox.FocusLost:Connect(function(enter) if enter then inputConfig.Callback(TextBox.Text) end end)
            
            return {Set = function(_, t) TextBox.Text = t end, Get = function() return TextBox.Text end}
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local Label = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, 35)})
            Corner(Label, 6)
            local LabelText = Create("TextLabel", {Parent = Label, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(1, -30, 1, 0), Font = Enum.Font.Gotham, Text = text, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            return {Set = function(_, t) LabelText.Text = t end}
        end
        
        -- Keybind
        function Tab:CreateKeybind(config)
            config = config or {}
            local keybindConfig = {
                Name = config.Name or "Keybind",
                Description = config.Description,
                CurrentKeybind = config.CurrentKeybind or Enum.KeyCode.E,
                Callback = config.Callback or function() end
            }
            local CurrentKey = keybindConfig.CurrentKeybind
            local Listening = false
            local height = keybindConfig.Description and 55 or 38
            
            local Keybind = Create("TextButton", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, height), Text = "", AutoButtonColor = false})
            Corner(Keybind, 6)
            
            Create("TextLabel", {Parent = Keybind, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, keybindConfig.Description and 8 or 0), Size = UDim2.new(1, -100, 0, keybindConfig.Description and 20 or height), Font = Enum.Font.GothamBold, Text = keybindConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            if keybindConfig.Description then
                Create("TextLabel", {Parent = Keybind, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 28), Size = UDim2.new(1, -100, 0, 20), Font = Enum.Font.Gotham, Text = keybindConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            local KeyLabel = Create("TextLabel", {Parent = Keybind, BackgroundColor3 = Theme.Toggle, Position = UDim2.new(1, -85, 0.5, -15), Size = UDim2.new(0, 70, 0, 30), Font = Enum.Font.GothamBold, Text = CurrentKey.Name, TextColor3 = Theme.Text, TextSize = 12})
            Corner(KeyLabel, 4)
            
            Keybind.MouseButton1Click:Connect(function()
                Listening = true
                KeyLabel.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    CurrentKey = input.KeyCode
                    KeyLabel.Text = CurrentKey.Name
                    Listening = false
                elseif not processed and input.KeyCode == CurrentKey then
                    keybindConfig.Callback(CurrentKey)
                end
            end)
            
            Keybind.MouseEnter:Connect(function() Tween(Keybind, {BackgroundColor3 = Theme.ButtonHover}, 0.15) end)
            Keybind.MouseLeave:Connect(function() Tween(Keybind, {BackgroundColor3 = Theme.Button}, 0.15) end)
            
            return {Set = function(_, key) CurrentKey = key KeyLabel.Text = key.Name end, Get = function() return CurrentKey end}
        end
        
        -- ColorPicker
        function Tab:CreateColorPicker(config)
            config = config or {}
            local colorConfig = {
                Name = config.Name or "Color Picker",
                Description = config.Description,
                Color = config.Color or Color3.fromRGB(255, 255, 255),
                Callback = config.Callback or function() end
            }
            local CurrentColor = colorConfig.Color
            local Opened = false
            local baseHeight = colorConfig.Description and 55 or 38
            
            local ColorPicker = Create("Frame", {Parent = TabContent, BackgroundColor3 = Theme.Button, Size = UDim2.new(1, 0, 0, baseHeight), ClipsDescendants = true})
            Corner(ColorPicker, 6)
            
            local PickerBtn = Create("TextButton", {Parent = ColorPicker, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, baseHeight), Text = ""})
            
            Create("TextLabel", {Parent = PickerBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, colorConfig.Description and 8 or 0), Size = UDim2.new(1, -80, 0, colorConfig.Description and 20 or baseHeight), Font = Enum.Font.GothamBold, Text = colorConfig.Name, TextColor3 = Theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
            
            if colorConfig.Description then
                Create("TextLabel", {Parent = PickerBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 28), Size = UDim2.new(1, -80, 0, 20), Font = Enum.Font.Gotham, Text = colorConfig.Description, TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
            end
            
            local ColorPreview = Create("Frame", {Parent = PickerBtn, BackgroundColor3 = CurrentColor, Position = UDim2.new(1, -55, 0.5, -15), Size = UDim2.new(0, 40, 0, 30)})
            Corner(ColorPreview, 4)
            
            -- Color picker panel
            local PickerPanel = Create("Frame", {Parent = ColorPicker, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, baseHeight + 5), Size = UDim2.new(1, -20, 0, 120)})
            
            -- Hue slider
            local HueBar = Create("Frame", {Parent = PickerPanel, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 0, 0, 100), Size = UDim2.new(1, 0, 0, 15)})
            Corner(HueBar, 4)
            
            local HueGradient = Create("UIGradient", {Parent = HueBar, Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })})
            
            local HueSlider = Create("Frame", {Parent = HueBar, BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 0, 0.5, -8), Size = UDim2.new(0, 4, 0, 16)})
            Corner(HueSlider, 2)
            Stroke(HueSlider, Color3.fromRGB(0, 0, 0), 1)
            
            -- Saturation/Value box
            local SVBox = Create("Frame", {Parent = PickerPanel, BackgroundColor3 = Color3.fromRGB(255, 0, 0), Size = UDim2.new(1, 0, 0, 90)})
            Corner(SVBox, 4)
            
            local SatGradient = Create("UIGradient", {Parent = SVBox, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})})
            
            local ValOverlay = Create("Frame", {Parent = SVBox, BackgroundColor3 = Color3.fromRGB(0, 0, 0), Size = UDim2.new(1, 0, 1, 0)})
            Corner(ValOverlay, 4)
            local ValGradient = Create("UIGradient", {Parent = ValOverlay, Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}), Rotation = 90})
            
            local SVCursor = Create("Frame", {Parent = SVBox, BackgroundColor3 = Color3.fromRGB(255, 255, 255), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 10, 0, 10)})
            Corner(SVCursor, 5)
            Stroke(SVCursor, Color3.fromRGB(0, 0, 0), 1)
            
            local H, S, V = 0, 1, 1
            
            local function UpdateColor()
                CurrentColor = Color3.fromHSV(H, S, V)
                ColorPreview.BackgroundColor3 = CurrentColor
                SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                colorConfig.Callback(CurrentColor)
            end
            
            local svDragging = false
            local hueDragging = false
            
            local SVBtn = Create("TextButton", {Parent = SVBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
            local HueBtn = Create("TextButton", {Parent = HueBar, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
            
            SVBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = true
                end
            end)
            SVBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = false
                end
            end)
            
            HueBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                end
            end)
            HueBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if svDragging then
                        S = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                        V = 1 - math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                        SVCursor.Position = UDim2.new(S, 0, 1 - V, 0)
                        UpdateColor()
                    elseif hueDragging then
                        H = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                        HueSlider.Position = UDim2.new(H, -2, 0.5, -8)
                        UpdateColor()
                    end
                end
            end)
            
            PickerBtn.MouseButton1Click:Connect(function()
                Opened = not Opened
                local h = Opened and (baseHeight + 130) or baseHeight
                Tween(ColorPicker, {Size = UDim2.new(1, 0, 0, h)}, 0.25)
            end)
            
            return {Set = function(_, c) CurrentColor = c H, S, V = c:ToHSV() ColorPreview.BackgroundColor3 = c SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1) SVCursor.Position = UDim2.new(S, 0, 1 - V, 0) HueSlider.Position = UDim2.new(H, -2, 0.5, -8) colorConfig.Callback(c) end, Get = function() return CurrentColor end}
        end
        
        return Tab
    end
    
    self.Window = Window
    return Window
end

return MinrLib
