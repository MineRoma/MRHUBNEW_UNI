--[[
    MinrLib - UI Library
    Часть 1: Core + Window
]]

local MinrLib = {}

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

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

-- Хранилище
MinrLib.Window = nil
MinrLib.Theme = MinrLib.Themes.Default
MinrLib.Notifications = {}

--[[
    СОЗДАНИЕ ОКНА
]]
function MinrLib:CreateWindow(config)
    config = config or {}
    
    local WindowConfig = {
        Name = config.Name or "MinrLib",
        Theme = config.Theme or "Default",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
        LoadingEnabled = config.LoadingEnabled ~= false,
        KeySystem = config.KeySystem or false,
        Key = config.Key or {""},
    }
    
    -- Установка темы
    self.Theme = self.Themes[WindowConfig.Theme] or self.Themes.Default
    local Theme = self.Theme
    
    -- Главный ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "MinrLib",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Контейнер уведомлений (правый нижний угол)
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
    
    --[[
        ГЛАВНЫЙ ФРЕЙМ
        Использую Scale для адаптивности!
    ]]
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        -- Scale позиция - центр экрана
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        -- Размер: Scale + Offset для баланса
        -- На телефоне будет меньше, на ПК - норм
        Size = IsMobile and UDim2.new(0.95, 0, 0.7, 0) or UDim2.new(0, 550, 0, 400),
        ClipsDescendants = true,
        BackgroundTransparency = 1
    })
    Corner(Main, 10)
    
    -- Constraint для мин/макс размера
    Create("UISizeConstraint", {
        Parent = Main,
        MinSize = Vector2.new(350, 300),
        MaxSize = Vector2.new(700, 500)
    })
    
    --[[
        ВЕРХНЯЯ ПАНЕЛЬ (TopBar)
    ]]
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = Main,
        BackgroundColor3 = Theme.TopBar,
        Size = UDim2.new(1, 0, 0, 45), -- Полная ширина
        BackgroundTransparency = 1
    })
    Corner(TopBar, 10)
    
    -- Заголовок
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
    
    -- Кнопки управления
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
    
    --[[
        ПАНЕЛЬ ТАБОВ
    ]]
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
    
    --[[
        КОНТЕЙНЕР КОНТЕНТА
    ]]
    local ContentContainer = Create("Frame", {
        Name = "Content",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 90),
        Size = UDim2.new(1, 0, 1, -90) -- От низа TabBar до конца
    })
    
    --[[
        МОБИЛЬНАЯ КНОПКА
    ]]
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
        
        -- Драг мобильной кнопки
        local dragging = false
        local dragStart, startPos
        
        MobileBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MobileBtn.Position
            end
        end)
        
        MobileBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                MobileBtn.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
    
    --[[
        WINDOW OBJECT
    ]]
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
    
    --[[
        АНИМАЦИЯ ПОЯВЛЕНИЯ
    ]]
    Main.Size = IsMobile and UDim2.new(0.95, 0, 0, 0) or UDim2.new(0, 550, 0, 0)
    
    task.spawn(function()
        task.wait(0.1)
        Tween(Main, {
            BackgroundTransparency = 0,
            Size = IsMobile and UDim2.new(0.95, 0, 0.7, 0) or UDim2.new(0, 550, 0, 400)
        }, 0.4)
        Tween(TopBar, {BackgroundTransparency = 0}, 0.4)
        Tween(TabBar, {BackgroundTransparency = 0}, 0.4)
        Tween(Title, {TextTransparency = 0}, 0.4)
        Tween(CloseBtn, {BackgroundTransparency = 0}, 0.4)
        Tween(MinimizeBtn, {BackgroundTransparency = 0}, 0.4)
        
        task.wait(0.5)
        -- Уведомление о клавише
        if not IsMobile then
            Window:Notify({
                Title = "GUI Loaded",
                Text = "Press " .. WindowConfig.ToggleKey.Name .. " to toggle",
                Duration = 4,
                Type = "Info"
            })
        end
    end)
    
    --[[
        ДРАГ ОКНА
    ]]
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
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    --[[
        КНОПКИ УПРАВЛЕНИЯ
    ]]
    CloseBtn.MouseButton1Click:Connect(function()
        Window.Visible = false
        Tween(Main, {
            Size = IsMobile and UDim2.new(0.95, 0, 0, 0) or UDim2.new(0, 550, 0, 0),
            BackgroundTransparency = 1
        }, 0.3)
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
    
    -- Toggle клавиша (ПК)
    if not IsMobile then
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == WindowConfig.ToggleKey then
                Window.Visible = not Window.Visible
                Main.Visible = Window.Visible
            end
        end)
    end
    
    -- Мобильная кнопка toggle
    if MobileBtn then
        MobileBtn.MouseButton1Click:Connect(function()
            Window.Visible = not Window.Visible
            Main.Visible = Window.Visible
        end)
    end
    
    --[[
        УВЕДОМЛЕНИЯ
    ]]
    function Window:Notify(config)
        config = config or {}
        
        local notifConfig = {
            Title = config.Title or "Notification",
            Text = config.Text or "",
            Duration = config.Duration or 5,
            Type = config.Type or "Info" -- Info, Success, Warning, Error
        }
        
        local colors = {
            Info = Theme.Accent,
            Success = Color3.fromRGB(80, 180, 120),
            Warning = Color3.fromRGB(220, 160, 70),
            Error = Color3.fromRGB(220, 70, 70)
        }
        
        local icons = {
            Info = "ℹ",
            Success = "✓",
            Warning = "⚠",
            Error = "✕"
        }
        
        local Notif = Create("Frame", {
            Parent = NotifContainer,
            BackgroundColor3 = Theme.Background,
            Size = UDim2.new(1, 0, 0, 70),
            Position = UDim2.new(1, 50, 0, 0), -- Начинаем за экраном
            ClipsDescendants = true
        })
        Corner(Notif, 8)
        Stroke(Notif, colors[notifConfig.Type], 2)
        
        -- Иконка
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
        
        -- Заголовок
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
        
        -- Текст
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
        
        -- Прогресс бар
        local Progress = Create("Frame", {
            Parent = Notif,
            BackgroundColor3 = colors[notifConfig.Type],
            Position = UDim2.new(0, 0, 1, -3),
            Size = UDim2.new(1, 0, 0, 3)
        })
        
        -- Анимация появления
        Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        
        -- Анимация прогресса
        Tween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, notifConfig.Duration)
        
        -- Удаление
        task.delay(notifConfig.Duration, function()
            Tween(Notif, {Position = UDim2.new(1, 50, 0, 0)}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    self.Window = Window
    return Window
end

return MinrLib
--[[
    MinrLib - Часть 2
    Табы + Button, Toggle, Slider
]]

--[[
    СОЗДАНИЕ ТАБА
]]
function MinrLib.Window:CreateTab(config)
    config = config or {}
    
    local tabConfig = {
        Name = config.Name or "Tab",
        Icon = config.Icon or nil -- rbxassetid://...
    }
    
    local Window = self
    local Theme = Window.Theme
    
    local Tab = {
        Name = tabConfig.Name,
        Elements = {}
    }
    
    --[[
        КНОПКА ТАБА
    ]]
    local TabBtn = Create("TextButton", {
        Name = tabConfig.Name,
        Parent = Window.TabScroll,
        BackgroundColor3 = Theme.Tab,
        Size = UDim2.new(0, tabConfig.Icon and 110 or 90, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "",
        AutoButtonColor = false
    })
    Corner(TabBtn, 6)
    
    -- Иконка таба (если есть)
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
    
    -- Текст таба
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
    
    --[[
        КОНТЕНТ ТАБА (ScrollingFrame)
    ]]
    local TabContent = Create("ScrollingFrame", {
        Name = tabConfig.Name .. "_Content",
        Parent = Window.ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    })
    
    Create("UIListLayout", {
        Parent = TabContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    })
    
    Create("UIPadding", {
        Parent = TabContent,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    })
    
    Tab.Button = TabBtn
    Tab.Content = TabContent
    
    --[[
        ВЫБОР ТАБА
    ]]
    local function SelectTab()
        -- Сброс всех табов
        for _, tab in pairs(Window.Tabs) do
            tab.Content.Visible = false
            Tween(tab.Button, {BackgroundColor3 = Theme.Tab}, 0.2)
        end
        
        -- Активация текущего
        TabContent.Visible = true
        Tween(TabBtn, {BackgroundColor3 = Theme.TabActive}, 0.2)
        Window.CurrentTab = Tab
    end
    
    TabBtn.MouseButton1Click:Connect(SelectTab)
    
    -- Hover эффект
    TabBtn.MouseEnter:Connect(function()
        if Window.CurrentTab ~= Tab then
            Tween(TabBtn, {BackgroundColor3 = Theme.ElementHover}, 0.15)
        end
    end)
    
    TabBtn.MouseLeave:Connect(function()
        if Window.CurrentTab ~= Tab then
            Tween(TabBtn, {BackgroundColor3 = Theme.Tab}, 0.15)
        end
    end)
    
    -- Добавляем в список
    table.insert(Window.Tabs, Tab)
    
    -- Первый таб активен по умолчанию
    if #Window.Tabs == 1 then
        SelectTab()
    end
    
    --[[
        =====================================
        ЭЛЕМЕНТЫ
        =====================================
    ]]
    
    --[[
        SECTION (разделитель)
    ]]
    function Tab:CreateSection(name)
        local Section = Create("Frame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25)
        })
        
        Create("TextLabel", {
            Parent = Section,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = name,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Линия
        Create("Frame", {
            Parent = Section,
            BackgroundColor3 = Theme.SubText,
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, 0, 1, -1),
            Size = UDim2.new(1, 0, 0, 1)
        })
    end
    
    --[[
        BUTTON
    ]]
    function Tab:CreateButton(config)
        config = config or {}
        
        local btnConfig = {
            Name = config.Name or "Button",
            Description = config.Description or nil,
            Callback = config.Callback or function() end
        }
        
        local hasDesc = btnConfig.Description ~= nil
        local height = hasDesc and 50 or 36
        
        local Button = Create("TextButton", {
            Parent = TabContent,
            BackgroundColor3 = Theme.Element,
            Size = UDim2.new(1, 0, 0, height),
            Text = "",
            AutoButtonColor = false
        })
        Corner(Button, 6)
        
        -- Название
        Create("TextLabel", {
            Parent = Button,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0),
            Size = UDim2.new(1, -50, 0, hasDesc and 18 or height),
            Font = Enum.Font.GothamBold,
            Text = btnConfig.Name,
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Описание
        if hasDesc then
            Create("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 24),
                Size = UDim2.new(1, -50, 0, 18),
                Font = Enum.Font.Gotham,
                Text = btnConfig.Description,
                TextColor3 = Theme.SubText,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        -- Стрелка
        Create("TextLabel", {
            Parent = Button,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -35, 0, 0),
            Size = UDim2.new(0, 25, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "→",
            TextColor3 = Theme.Accent,
            TextSize = 16
        })
        
        -- Hover
        Button.MouseEnter:Connect(function()
            Tween(Button, {BackgroundColor3 = Theme.ElementHover}, 0.15)
        end)
        
        Button.MouseLeave:Connect(function()
            Tween(Button, {BackgroundColor3 = Theme.Element}, 0.15)
        end)
        
        -- Click
        Button.MouseButton1Click:Connect(function()
            -- Ripple эффект
            local ripple = Create("Frame", {
                Parent = Button,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.8,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })
            Corner(ripple, 100)
            
            Tween(ripple, {
                Size = UDim2.new(2, 0, 2, 0),
                BackgroundTransparency = 1
            }, 0.4)
            
            task.delay(0.4, function()
                ripple:Destroy()
            end)
            
            btnConfig.Callback()
        end)
        
        -- API
        local ButtonAPI = {}
        
        function ButtonAPI:SetText(text)
            Button:FindFirstChild("TextLabel").Text = text
        end
        
        return ButtonAPI
    end
    
    --[[
        TOGGLE
    ]]
    function Tab:CreateToggle(config)
        config = config or {}
        
        local toggleConfig = {
            Name = config.Name or "Toggle",
            Description = config.Description or nil,
            CurrentValue = config.CurrentValue or false,
            Callback = config.Callback or function() end
        }
        
        local Enabled = toggleConfig.CurrentValue
        local hasDesc = toggleConfig.Description ~= nil
        local height = hasDesc and 50 or 36
        
        local Toggle = Create("TextButton", {
            Parent = TabContent,
            BackgroundColor3 = Theme.Element,
            Size = UDim2.new(1, 0, 0, height),
            Text = "",
            AutoButtonColor = false
        })
        Corner(Toggle, 6)
        
        -- Название
        Create("TextLabel", {
            Parent = Toggle,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0),
            Size = UDim2.new(1, -70, 0, hasDesc and 18 or height),
            Font = Enum.Font.GothamBold,
            Text = toggleConfig.Name,
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Описание
        if hasDesc then
            Create("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 24),
                Size = UDim2.new(1, -70, 0, 18),
                Font = Enum.Font.Gotham,
                Text = toggleConfig.Description,
                TextColor3 = Theme.SubText,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        -- Toggle indicator (pill shape)
        local Indicator = Create("Frame", {
            Parent = Toggle,
            BackgroundColor3 = Enabled and Theme.ToggleEnabled or Theme.Toggle,
            Position = UDim2.new(1, -52, 0.5, -10),
            Size = UDim2.new(0, 40, 0, 20)
        })
        Corner(Indicator, 10)
        
        -- Circle
        local Circle = Create("Frame", {
            Parent = Indicator,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16)
        })
        Corner(Circle, 8)
        
        local function UpdateToggle()
            if Enabled then
                Tween(Indicator, {BackgroundColor3 = Theme.ToggleEnabled}, 0.2)
                Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
            else
                Tween(Indicator, {BackgroundColor3 = Theme.Toggle}, 0.2)
                Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
            end
        end
        
        Toggle.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            UpdateToggle()
            toggleConfig.Callback(Enabled)
        end)
        
        -- Hover
        Toggle.MouseEnter:Connect(function()
            Tween(Toggle, {BackgroundColor3 = Theme.ElementHover}, 0.15)
        end)
        
        Toggle.MouseLeave:Connect(function()
            Tween(Toggle, {BackgroundColor3 = Theme.Element}, 0.15)
        end)
        
        -- API
        local ToggleAPI = {}
        
        function ToggleAPI:Set(value)
            Enabled = value
            UpdateToggle()
            toggleConfig.Callback(Enabled)
        end
        
        function ToggleAPI:Get()
            return Enabled
        end
        
        return ToggleAPI
    end
    
    --[[
        SLIDER
    ]]
    function Tab:CreateSlider(config)
        config = config or {}
        
        local sliderConfig = {
            Name = config.Name or "Slider",
            Description = config.Description or nil,
            Min = config.Min or 0,
            Max = config.Max or 100,
            CurrentValue = config.CurrentValue or 50,
            Increment = config.Increment or 1,
            Callback = config.Callback or function() end
        }
        
        local Value = sliderConfig.CurrentValue
        local hasDesc = sliderConfig.Description ~= nil
        local height = hasDesc and 65 or 50
        
        local Slider = Create("Frame", {
            Parent = TabContent,
            BackgroundColor3 = Theme.Element,
            Size = UDim2.new(1, 0, 0, height)
        })
        Corner(Slider, 6)
        
        -- Название
        Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, hasDesc and 6 or 4),
            Size = UDim2.new(1, -70, 0, 16),
            Font = Enum.Font.GothamBold,
            Text = sliderConfig.Name,
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Значение
        local ValueLabel = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -55, 0, hasDesc and 6 or 4),
            Size = UDim2.new(0, 45, 0, 16),
            Font = Enum.Font.GothamBold,
            Text = tostring(Value),
            TextColor3 = Theme.Accent,
            TextSize = 13
        })
        
        -- Описание
        if hasDesc then
            Create("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 22),
                Size = UDim2.new(1, -24, 0, 14),
                Font = Enum.Font.Gotham,
                Text = sliderConfig.Description,
                TextColor3 = Theme.SubText,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        -- Slider Bar
        local SliderBar = Create("Frame", {
            Parent = Slider,
            BackgroundColor3 = Theme.Toggle,
            Position = UDim2.new(0, 12, 1, -18),
            Size = UDim2.new(1, -24, 0, 6)
        })
        Corner(SliderBar, 3)
        
        -- Fill
        local fillPercent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
        
        local SliderFill = Create("Frame", {
            Parent = SliderBar,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(fillPercent, 0, 1, 0)
        })
        Corner(SliderFill, 3)
        
        -- Knob
        local Knob = Create("Frame", {
            Parent = SliderBar,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(fillPercent, -8, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            AnchorPoint = Vector2.new(0, 0.5)
        })
        Corner(Knob, 8)
        
        -- Interaction
        local SliderBtn = Create("TextButton", {
            Parent = SliderBar,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0, -10, 0, -10),
            Text = ""
        })
        
        local dragging = false
        
        local function UpdateSlider(input)
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            
            local relativeX = math.clamp(input.Position.X - barPos, 0, barSize)
            local percent = relativeX / barSize
            
            local rawValue = sliderConfig.Min + (percent * (sliderConfig.Max - sliderConfig.Min))
            Value = math.floor(rawValue / sliderConfig.Increment + 0.5) * sliderConfig.Increment
            Value = math.clamp(Value, sliderConfig.Min, sliderConfig.Max)
            
            local newPercent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
            
            Tween(SliderFill, {Size = UDim2.new(newPercent, 0, 1, 0)}, 0.05)
            Tween(Knob, {Position = UDim2.new(newPercent, -8, 0.5, -8)}, 0.05)
            ValueLabel.Text = tostring(Value)
            
            sliderConfig.Callback(Value)
        end
        
        SliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                UpdateSlider(input)
            end
        end)
        
        SliderBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging then
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(input)
                end
            end
        end)
        
        -- API
        local SliderAPI = {}
        
        function SliderAPI:Set(value)
            Value = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
            local percent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
            
            Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
            Tween(Knob, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.2)
            ValueLabel.Text = tostring(Value)
            
            sliderConfig.Callback(Value)
        end
        
        function SliderAPI:Get()
            return Value
        end
        
        return SliderAPI
    end
    
    return Tab
end
--[[
    MinrLib - Часть 3
    Dropdown, Input, Keybind
]]

--[[
    DROPDOWN
]]
function Tab:CreateDropdown(config)
    config = config or {}
    
    local dropConfig = {
        Name = config.Name or "Dropdown",
        Description = config.Description or nil,
        Options = config.Options or {"Option 1", "Option 2", "Option 3"},
        CurrentOption = config.CurrentOption or nil,
        MultiSelect = config.MultiSelect or false,
        Callback = config.Callback or function() end
    }
    
    local Selected = dropConfig.MultiSelect and {} or (dropConfig.CurrentOption or dropConfig.Options[1])
    local Opened = false
    local hasDesc = dropConfig.Description ~= nil
    local baseHeight = hasDesc and 50 or 36
    
    local Dropdown = Create("Frame", {
        Parent = TabContent,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, 0, 0, baseHeight),
        ClipsDescendants = true
    })
    Corner(Dropdown, 6)
    
    -- Кнопка открытия
    local DropdownBtn = Create("TextButton", {
        Parent = Dropdown,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, baseHeight),
        Text = ""
    })
    
    -- Название
    Create("TextLabel", {
        Parent = DropdownBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0),
        Size = UDim2.new(0.5, 0, 0, hasDesc and 18 or baseHeight),
        Font = Enum.Font.GothamBold,
        Text = dropConfig.Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Текущее значение
    local SelectedLabel = Create("TextLabel", {
        Parent = DropdownBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, hasDesc and 6 or 0),
        Size = UDim2.new(0.5, -40, 0, hasDesc and 18 or baseHeight),
        Font = Enum.Font.Gotham,
        Text = dropConfig.MultiSelect and "None" or Selected,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    -- Стрелка
    local Arrow = Create("TextLabel", {
        Parent = DropdownBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 20, 0, baseHeight),
        Font = Enum.Font.GothamBold,
        Text = "▼",
        TextColor3 = Theme.SubText,
        TextSize = 10
    })
    
    -- Описание
    if hasDesc then
        Create("TextLabel", {
            Parent = DropdownBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 24),
            Size = UDim2.new(1, -24, 0, 18),
            Font = Enum.Font.Gotham,
            Text = dropConfig.Description,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    -- Контейнер опций
    local OptionsContainer = Create("Frame", {
        Parent = Dropdown,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, baseHeight + 4),
        Size = UDim2.new(1, -16, 0, 0)
    })
    
    Create("UIListLayout", {
        Parent = OptionsContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    
    local function UpdateSelected()
        if dropConfig.MultiSelect then
            if #Selected == 0 then
                SelectedLabel.Text = "None"
            elseif #Selected == 1 then
                SelectedLabel.Text = Selected[1]
            else
                SelectedLabel.Text = #Selected .. " selected"
            end
        else
            SelectedLabel.Text = Selected
        end
    end
    
    local function CreateOption(optionName)
        local Option = Create("TextButton", {
            Name = optionName,
            Parent = OptionsContainer,
            BackgroundColor3 = Theme.Toggle,
            Size = UDim2.new(1, 0, 0, 28),
            Font = Enum.Font.Gotham,
            Text = "  " .. optionName,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })
        Corner(Option, 4)
        
        -- Проверка выбран ли
        local function IsSelected()
            if dropConfig.MultiSelect then
                return table.find(Selected, optionName) ~= nil
            else
                return Selected == optionName
            end
        end
        
        if IsSelected() then
            Option.BackgroundColor3 = Theme.Accent
        end
        
        Option.MouseButton1Click:Connect(function()
            if dropConfig.MultiSelect then
                local index = table.find(Selected, optionName)
                if index then
                    table.remove(Selected, index)
                    Tween(Option, {BackgroundColor3 = Theme.Toggle}, 0.15)
                else
                    table.insert(Selected, optionName)
                    Tween(Option, {BackgroundColor3 = Theme.Accent}, 0.15)
                end
                UpdateSelected()
                dropConfig.Callback(Selected)
            else
                -- Single select
                for _, opt in pairs(OptionsContainer:GetChildren()) do
                    if opt:IsA("TextButton") then
                        Tween(opt, {BackgroundColor3 = Theme.Toggle}, 0.15)
                    end
                end
                Tween(Option, {BackgroundColor3 = Theme.Accent}, 0.15)
                Selected = optionName
                UpdateSelected()
                dropConfig.Callback(Selected)
                
                -- Закрыть
                Opened = false
                local targetHeight = baseHeight
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
                Tween(Arrow, {Rotation = 0}, 0.25)
            end
        end)
        
        -- Hover
        Option.MouseEnter:Connect(function()
            if not IsSelected() then
                Tween(Option, {BackgroundColor3 = Theme.ElementHover}, 0.1)
            end
        end)
        
        Option.MouseLeave:Connect(function()
            if not IsSelected() then
                Tween(Option, {BackgroundColor3 = Theme.Toggle}, 0.1)
            end
        end)
    end
    
    -- Создание опций
    for _, option in ipairs(dropConfig.Options) do
        CreateOption(option)
    end
    
    -- Открытие/закрытие
    DropdownBtn.MouseButton1Click:Connect(function()
        Opened = not Opened
        
        local optionHeight = #dropConfig.Options * 32
        local targetHeight = Opened and (baseHeight + optionHeight + 12) or baseHeight
        
        Tween(Dropdown, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
        Tween(Arrow, {Rotation = Opened and 180 or 0}, 0.25)
    end)
    
    -- API
    local DropdownAPI = {}
    
    function DropdownAPI:Set(option)
        if dropConfig.MultiSelect then
            Selected = type(option) == "table" and option or {option}
        else
            Selected = option
        end
        UpdateSelected()
        
        -- Обновить визуал
        for _, opt in pairs(OptionsContainer:GetChildren()) do
            if opt:IsA("TextButton") then
                local isSelected = dropConfig.MultiSelect and table.find(Selected, opt.Name) or Selected == opt.Name
                opt.BackgroundColor3 = isSelected and Theme.Accent or Theme.Toggle
            end
        end
        
        dropConfig.Callback(Selected)
    end
    
    function DropdownAPI:Get()
        return Selected
    end
    
    function DropdownAPI:Refresh(newOptions)
        -- Очистить старые
        for _, child in pairs(OptionsContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        dropConfig.Options = newOptions
        Selected = dropConfig.MultiSelect and {} or newOptions[1]
        UpdateSelected()
        
        for _, option in ipairs(newOptions) do
            CreateOption(option)
        end
    end
    
    return DropdownAPI
end

--[[
    INPUT (TextBox)
]]
function Tab:CreateInput(config)
    config = config or {}
    
    local inputConfig = {
        Name = config.Name or "Input",
        Description = config.Description or nil,
        PlaceholderText = config.PlaceholderText or "Type here...",
        ClearOnFocus = config.ClearOnFocus or false,
        Callback = config.Callback or function() end
    }
    
    local hasDesc = inputConfig.Description ~= nil
    local height = hasDesc and 70 or 55
    
    local Input = Create("Frame", {
        Parent = TabContent,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, 0, 0, height)
    })
    Corner(Input, 6)
    
    -- Название
    Create("TextLabel", {
        Parent = Input,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 6),
        Size = UDim2.new(1, -24, 0, 16),
        Font = Enum.Font.GothamBold,
        Text = inputConfig.Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Описание
    if hasDesc then
        Create("TextLabel", {
            Parent = Input,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 22),
            Size = UDim2.new(1, -24, 0, 14),
            Font = Enum.Font.Gotham,
            Text = inputConfig.Description,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    -- TextBox
    local TextBox = Create("TextBox", {
        Parent = Input,
        BackgroundColor3 = Theme.Toggle,
        Position = UDim2.new(0, 10, 1, -32),
        Size = UDim2.new(1, -20, 0, 26),
        Font = Enum.Font.Gotham,
        PlaceholderText = inputConfig.PlaceholderText,
        PlaceholderColor3 = Theme.SubText,
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = 12,
        ClearTextOnFocus = inputConfig.ClearOnFocus
    })
    Corner(TextBox, 4)
    
    -- Focus эффект
    TextBox.Focused:Connect(function()
        Tween(TextBox, {BackgroundColor3 = Theme.ElementHover}, 0.15)
    end)
    
    TextBox.FocusLost:Connect(function(enterPressed)
        Tween(TextBox, {BackgroundColor3 = Theme.Toggle}, 0.15)
        if enterPressed then
            inputConfig.Callback(TextBox.Text)
        end
    end)
    
    -- API
    local InputAPI = {}
    
    function InputAPI:Set(text)
        TextBox.Text = text
    end
    
    function InputAPI:Get()
        return TextBox.Text
    end
    
    return InputAPI
end

--[[
    KEYBIND
]]
function Tab:CreateKeybind(config)
    config = config or {}
    
    local keybindConfig = {
        Name = config.Name or "Keybind",
        Description = config.Description or nil,
        CurrentKeybind = config.CurrentKeybind or "None",
        Callback = config.Callback or function() end
    }
    
    local CurrentKey = keybindConfig.CurrentKeybind
    local Listening = false
    local hasDesc = keybindConfig.Description ~= nil
    local height = hasDesc and 50 or 36
    
    local Keybind = Create("Frame", {
        Parent = TabContent,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, 0, 0, height)
    })
    Corner(Keybind, 6)
    
    -- Название
    Create("TextLabel", {
        Parent = Keybind,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0),
        Size = UDim2.new(1, -90, 0, hasDesc and 18 or height),
        Font = Enum.Font.GothamBold,
        Text = keybindConfig.Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Описание
    if hasDesc then
        Create("TextLabel", {
            Parent = Keybind,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 24),
            Size = UDim2.new(1, -90, 0, 18),
            Font = Enum.Font.Gotham,
            Text = keybindConfig.Description,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    -- Кнопка бинда
    local KeyBtn = Create("TextButton", {
        Parent = Keybind,
        BackgroundColor3 = Theme.Toggle,
        Position = UDim2.new(1, -75, 0.5, -13),
        Size = UDim2.new(0, 65, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = CurrentKey,
        TextColor3 = Theme.Accent,
        TextSize = 11,
        AutoButtonColor = false
    })
    Corner(KeyBtn, 4)
    
    KeyBtn.MouseButton1Click:Connect(function()
        Listening = true
        KeyBtn.Text = "..."
        Tween(KeyBtn, {BackgroundColor3 = Theme.Accent}, 0.15)
        Tween(KeyBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                CurrentKey = input.KeyCode.Name
                KeyBtn.Text = CurrentKey
                Listening = false
                Tween(KeyBtn, {BackgroundColor3 = Theme.Toggle}, 0.15)
                Tween(KeyBtn, {TextColor3 = Theme.Accent}, 0.15)
            end
        elseif not processed and CurrentKey ~= "None" then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode.Name == CurrentKey then
                    keybindConfig.Callback(CurrentKey)
                end
            end
        end
    end)
    
    -- API
    local KeybindAPI = {}
    
    function KeybindAPI:Set(key)
        CurrentKey = key
        KeyBtn.Text = key
    end
    
    function KeybindAPI:Get()
        return CurrentKey
    end
    
    return KeybindAPI
end
--[[
    MinrLib - Часть 4
    Label, Paragraph, ColorPicker + Полный код
]]

--[[
    LABEL (просто текст)
]]
function Tab:CreateLabel(text)
    local Label = Create("Frame", {
        Parent = TabContent,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, 0, 0, 32)
    })
    Corner(Label, 6)
    
    local LabelText = Create("TextLabel", {
        Parent = Label,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- API
    local LabelAPI = {}
    
    function LabelAPI:Set(newText)
        LabelText.Text = newText
    end
    
    return LabelAPI
end

--[[
    PARAGRAPH (заголовок + текст)
]]
function Tab:CreateParagraph(config)
    config = config or {}
    
    local paraConfig = {
        Title = config.Title or "Title",
        Content = config.Content or "Content text here..."
    }
    
    -- Вычисляем высоту на основе текста
    local textService = game:GetService("TextService")
    local textSize = textService:GetTextSize(
        paraConfig.Content,
        12,
        Enum.Font.Gotham,
        Vector2.new(500, math.huge)
    )
    local height = math.max(60, textSize.Y + 40)
    
    local Paragraph = Create("Frame", {
        Parent = TabContent,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, 0, 0, height)
    })
    Corner(Paragraph, 6)
    
    -- Заголовок
    local TitleLabel = Create("TextLabel", {
        Parent = Paragraph,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -24, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = paraConfig.Title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Контент
    local ContentLabel = Create("TextLabel", {
        Parent = Paragraph,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 28),
        Size = UDim2.new(1, -24, 1, -36),
        Font = Enum.Font.Gotham,
        Text = paraConfig.Content,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true
    })
    
    -- API
    local ParagraphAPI = {}
    
    function ParagraphAPI:Set(config)
        if config.Title then
            TitleLabel.Text = config.Title
        end
        if config.Content then
            ContentLabel.Text = config.Content
        end
    end
    
    return ParagraphAPI
end

--[[
    COLOR PICKER
]]
function Tab:CreateColorPicker(config)
    config = config or {}
    
    local colorConfig = {
        Name = config.Name or "Color Picker",
        Description = config.Description or nil,
        Color = config.Color or Color3.fromRGB(255, 255, 255),
        Callback = config.Callback or function() end
    }
    
    local CurrentColor = colorConfig.Color
    local CurrentHue, CurrentSat, CurrentVal = CurrentColor:ToHSV()
    local Opened = false
    local hasDesc = colorConfig.Description ~= nil
    local baseHeight = hasDesc and 50 or 36
    
    local ColorPicker = Create("Frame", {
        Parent = TabContent,
        BackgroundColor3 = Theme.Element,
        Size = UDim2.new(1, 0, 0, baseHeight),
        ClipsDescendants = true
    })
    Corner(ColorPicker, 6)
    
    -- Кнопка
    local ColorBtn = Create("TextButton", {
        Parent = ColorPicker,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, baseHeight),
        Text = ""
    })
    
    -- Название
    Create("TextLabel", {
        Parent = ColorBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, hasDesc and 6 or 0),
        Size = UDim2.new(1, -60, 0, hasDesc and 18 or baseHeight),
        Font = Enum.Font.GothamBold,
        Text = colorConfig.Name,
        TextColor3 = Theme.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Описание
    if hasDesc then
        Create("TextLabel", {
            Parent = ColorBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 24),
            Size = UDim2.new(1, -60, 0, 18),
            Font = Enum.Font.Gotham,
            Text = colorConfig.Description,
            TextColor3 = Theme.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    
    -- Превью цвета
    local ColorPreview = Create("Frame", {
        Parent = ColorBtn,
        BackgroundColor3 = CurrentColor,
        Position = UDim2.new(1, -45, 0.5, -12),
        Size = UDim2.new(0, 35, 0, 24)
    })
    Corner(ColorPreview, 4)
    Stroke(ColorPreview, Color3.fromRGB(60, 60, 65), 1)
    
    -- Контейнер пикера
    local PickerContainer = Create("Frame", {
        Parent = ColorPicker,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, baseHeight + 8),
        Size = UDim2.new(1, -20, 0, 120)
    })
    
    -- Основной пикер (Saturation/Value)
    local MainPicker = Create("Frame", {
        Parent = PickerContainer,
        BackgroundColor3 = Color3.fromHSV(CurrentHue, 1, 1),
        Size = UDim2.new(1, -30, 0, 100)
    })
    Corner(MainPicker, 4)
    
    -- Градиент белого (слева направо)
    local WhiteGradient = Create("UIGradient", {
        Parent = MainPicker,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    
    -- Оверлей черного (сверху вниз)
    local BlackOverlay = Create("Frame", {
        Parent = MainPicker,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2
    })
    Corner(BlackOverlay, 4)
    
    Create("UIGradient", {
        Parent = BlackOverlay,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90
    })
    
    -- Курсор на основном пикере
    local MainCursor = Create("Frame", {
        Parent = MainPicker,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(CurrentSat, -6, 1 - CurrentVal, -6),
        Size = UDim2.new(0, 12, 0, 12),
        ZIndex = 3
    })
    Corner(MainCursor, 6)
    Stroke(MainCursor, Color3.fromRGB(0, 0, 0), 2)
    
    -- Hue слайдер
    local HueSlider = Create("Frame", {
        Parent = PickerContainer,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(1, -20, 0, 0),
        Size = UDim2.new(0, 15, 0, 100)
    })
    Corner(HueSlider, 4)
    
    -- Hue градиент
    Create("UIGradient", {
        Parent = HueSlider,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Rotation = 90
    })
    
    -- Hue курсор
    local HueCursor = Create("Frame", {
        Parent = HueSlider,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0.5, -8, CurrentHue, -3),
        Size = UDim2.new(0, 16, 0, 6),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    Corner(HueCursor, 2)
    Stroke(HueCursor, Color3.fromRGB(0, 0, 0), 1)
    
    local function UpdateColor()
        CurrentColor = Color3.fromHSV(CurrentHue, CurrentSat, CurrentVal)
        ColorPreview.BackgroundColor3 = CurrentColor
        MainPicker.BackgroundColor3 = Color3.fromHSV(CurrentHue, 1, 1)
        colorConfig.Callback(CurrentColor)
    end
    
    -- Взаимодействие с основным пикером
    local MainBtn = Create("TextButton", {
        Parent = MainPicker,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 4
    })
    
    local draggingMain = false
    
    local function UpdateMain(input)
        local pos = input.Position
        local relX = math.clamp((pos.X - MainPicker.AbsolutePosition.X) / MainPicker.AbsoluteSize.X, 0, 1)
        local relY = math.clamp((pos.Y - MainPicker.AbsolutePosition.Y) / MainPicker.AbsoluteSize.Y, 0, 1)
        
        CurrentSat = relX
        CurrentVal = 1 - relY
        
        MainCursor.Position = UDim2.new(relX, -6, relY, -6)
        UpdateColor()
    end
    
    MainBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = true
            UpdateMain(input)
        end
    end)
    
    MainBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMain = false
        end
    end)
    
    -- Взаимодействие с Hue слайдером
    local HueBtn = Create("TextButton", {
        Parent = HueSlider,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    
    local draggingHue = false
    
    local function UpdateHue(input)
        local pos = input.Position
        local relY = math.clamp((pos.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
        
        CurrentHue = relY
        HueCursor.Position = UDim2.new(0.5, -8, relY, -3)
        UpdateColor()
    end
    
    HueBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            UpdateHue(input)
        end
    end)
    
    HueBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingMain then
                UpdateMain(input)
            elseif draggingHue then
                UpdateHue(input)
            end
        end
    end)
    
    -- Открытие/закрытие
    ColorBtn.MouseButton1Click:Connect(function()
        Opened = not Opened
        local targetHeight = Opened and (baseHeight + 140) or baseHeight
        Tween(ColorPicker, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.25)
    end)
    
    -- API
    local ColorAPI = {}
    
    function ColorAPI:Set(color)
        CurrentColor = color
        CurrentHue, CurrentSat, CurrentVal = color:ToHSV()
        
        MainCursor.Position = UDim2.new(CurrentSat, -6, 1 - CurrentVal, -6)
        HueCursor.Position = UDim2.new(0.5, -8, CurrentHue, -3)
        
        ColorPreview.BackgroundColor3 = color
        MainPicker.BackgroundColor3 = Color3.fromHSV(CurrentHue, 1, 1)
        colorConfig.Callback(color)
    end
    
    function ColorAPI:Get()
        return CurrentColor
    end
    
    return ColorAPI
end
