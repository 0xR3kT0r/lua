--[[
    NexusUI - Modern Roblox UI Framework
    Version: 2.0.0
    Author: NexusUI Framework
    
    A fully-featured, production-ready UI library for Roblox
    with modern design, smooth animations, and clean API.
    
    Usage:
        local ui = loadstring(game:HttpGet("RAW_URL"))()
        local window = ui:Window({ Title = "My App", ... })
--]]

-- ============================================================
--  SERVICES
-- ============================================================
local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local TextService        = game:GetService("TextService")

local LocalPlayer        = Players.LocalPlayer
local Mouse              = LocalPlayer:GetMouse()

-- ============================================================
--  INTERNAL UTILITIES
-- ============================================================
local NexusUI = {}
NexusUI.__index = NexusUI

-- Tween helper
local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function TweenQuick(obj, props, duration, style, dir)
    duration = duration or 0.2
    style    = style    or Enum.EasingStyle.Quart
    dir      = dir      or Enum.EasingDirection.Out
    return Tween(obj, TweenInfo.new(duration, style, dir), props)
end

-- Rounded corner helper
local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

-- Padding helper
local function AddPadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 8)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.Parent = parent
    return p
end

-- Stroke helper
local function AddStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color        = color        or Color3.fromRGB(255,255,255)
    s.Thickness    = thickness    or 1
    s.Transparency = transparency or 0.85
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- Gradient helper
local function AddGradient(parent, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color    = ColorSequence.new(c0 or Color3.fromRGB(255,255,255), c1 or Color3.fromRGB(200,200,200))
    g.Rotation = rotation or 90
    g.Parent   = parent
    return g
end

-- Create text label
local function MakeLabel(parent, text, size, color, font, xAlign)
    local lbl = Instance.new("TextLabel")
    lbl.Text               = text  or ""
    lbl.TextSize           = size  or 14
    lbl.TextColor3         = color or Color3.fromRGB(255,255,255)
    lbl.Font               = font  or Enum.Font.GothamMedium
    lbl.TextXAlignment     = xAlign or Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Size               = UDim2.new(1, 0, 0, size and size + 4 or 18)
    lbl.Parent             = parent
    return lbl
end

-- ============================================================
--  THEME DEFINITIONS
-- ============================================================
local Themes = {
    Dark = {
        Background      = Color3.fromRGB(15, 15, 20),
        Surface         = Color3.fromRGB(22, 22, 30),
        SurfaceVariant  = Color3.fromRGB(30, 30, 42),
        Border          = Color3.fromRGB(50, 50, 70),
        TextPrimary     = Color3.fromRGB(235, 235, 245),
        TextSecondary   = Color3.fromRGB(140, 140, 165),
        TextMuted       = Color3.fromRGB(80, 80, 105),
        Accent          = Color3.fromRGB(0, 170, 255),
        AccentDim       = Color3.fromRGB(0, 100, 170),
        Success         = Color3.fromRGB(50, 210, 130),
        Warning         = Color3.fromRGB(255, 190, 50),
        Danger          = Color3.fromRGB(255, 75, 75),
        SliderTrack     = Color3.fromRGB(40, 40, 55),
        SectionHeader   = Color3.fromRGB(18, 18, 26),
        TooltipBg       = Color3.fromRGB(10, 10, 16),
    },
    Light = {
        Background      = Color3.fromRGB(245, 245, 252),
        Surface         = Color3.fromRGB(255, 255, 255),
        SurfaceVariant  = Color3.fromRGB(235, 235, 245),
        Border          = Color3.fromRGB(200, 200, 220),
        TextPrimary     = Color3.fromRGB(20, 20, 35),
        TextSecondary   = Color3.fromRGB(90, 90, 120),
        TextMuted       = Color3.fromRGB(160, 160, 185),
        Accent          = Color3.fromRGB(0, 140, 220),
        AccentDim       = Color3.fromRGB(0, 90, 160),
        Success         = Color3.fromRGB(30, 180, 100),
        Warning         = Color3.fromRGB(220, 155, 20),
        Danger          = Color3.fromRGB(220, 50, 50),
        SliderTrack     = Color3.fromRGB(210, 210, 230),
        SectionHeader   = Color3.fromRGB(240, 240, 250),
        TooltipBg       = Color3.fromRGB(20, 20, 35),
    }
}

-- ============================================================
--  TOOLTIP SYSTEM
-- ============================================================
local TooltipFrame
local TooltipLabel
local TooltipVisible = false

local function InitTooltip(screenGui, theme)
    TooltipFrame = Instance.new("Frame")
    TooltipFrame.Name              = "NexusTooltip"
    TooltipFrame.Size              = UDim2.fromOffset(200, 32)
    TooltipFrame.BackgroundColor3  = theme.TooltipBg
    TooltipFrame.BackgroundTransparency = 0.1
    TooltipFrame.BorderSizePixel   = 0
    TooltipFrame.ZIndex            = 100
    TooltipFrame.Visible           = false
    AddCorner(TooltipFrame, 6)
    AddStroke(TooltipFrame, theme.Border, 1, 0.6)

    TooltipLabel = Instance.new("TextLabel")
    TooltipLabel.Size              = UDim2.new(1, -16, 1, 0)
    TooltipLabel.Position          = UDim2.fromOffset(8, 0)
    TooltipLabel.BackgroundTransparency = 1
    TooltipLabel.TextColor3        = theme.TextPrimary
    TooltipLabel.TextSize          = 12
    TooltipLabel.Font              = Enum.Font.Gotham
    TooltipLabel.TextXAlignment    = Enum.TextXAlignment.Left
    TooltipLabel.TextWrapped       = true
    TooltipLabel.ZIndex            = 101
    TooltipLabel.Parent            = TooltipFrame

    TooltipFrame.Parent = screenGui
end

local function ShowTooltip(text)
    if not TooltipFrame or not text or text == "" then return end
    TooltipLabel.Text = text
    local ts = TextService:GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(220, 200))
    TooltipFrame.Size = UDim2.fromOffset(ts.X + 20, math.max(28, ts.Y + 12))
    TooltipFrame.Visible = true
    TooltipVisible = true
end

local function HideTooltip()
    if TooltipFrame then
        TooltipFrame.Visible = false
        TooltipVisible = false
    end
end

RunService.RenderStepped:Connect(function()
    if TooltipVisible and TooltipFrame then
        local mx = Mouse.X
        local my = Mouse.Y
        local vp = workspace.CurrentCamera.ViewportSize
        local fw = TooltipFrame.AbsoluteSize.X
        local fh = TooltipFrame.AbsoluteSize.Y
        local px = mx + 16
        local py = my + 16
        if px + fw > vp.X then px = mx - fw - 8 end
        if py + fh > vp.Y then py = my - fh - 8 end
        TooltipFrame.Position = UDim2.fromOffset(px, py)
    end
end)

-- ============================================================
--  KEYBIND SYSTEM
-- ============================================================
local KeybindRegistry = {}

local function RegisterKeybind(key, callback)
    KeybindRegistry[key] = callback
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local kn = input.KeyCode.Name
    if KeybindRegistry[kn] then
        KeybindRegistry[kn]()
    end
end)

-- ============================================================
--  NOTIFICATION SYSTEM
-- ============================================================
local NotifContainer
local notifCount = 0

local function InitNotifications(screenGui, theme)
    NotifContainer = Instance.new("Frame")
    NotifContainer.Name              = "NexusNotifs"
    NotifContainer.Size              = UDim2.fromOffset(300, 0)
    NotifContainer.Position          = UDim2.new(1, -315, 1, -10)
    NotifContainer.AnchorPoint       = Vector2.new(0, 1)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.BorderSizePixel   = 0
    NotifContainer.ZIndex            = 90
    NotifContainer.Parent            = screenGui

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = NotifContainer
end

local function Notify(opts, theme)
    opts = opts or {}
    local title    = opts.Title   or "Notification"
    local message  = opts.Message or ""
    local duration = opts.Duration or 4
    local ntype    = opts.Type    or "Info"

    notifCount = notifCount + 1

    local accentColor = theme.Accent
    if ntype == "Success" then accentColor = theme.Success
    elseif ntype == "Warning" then accentColor = theme.Warning
    elseif ntype == "Error"   then accentColor = theme.Danger end

    local card = Instance.new("Frame")
    card.Name             = "Notif_" .. notifCount
    card.Size             = UDim2.fromOffset(300, 68)
    card.BackgroundColor3 = theme.Surface
    card.BorderSizePixel  = 0
    card.ClipsDescendants = true
    AddCorner(card, 10)
    AddStroke(card, theme.Border, 1, 0.6)

    local accent = Instance.new("Frame")
    accent.Size            = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = accentColor
    accent.BorderSizePixel = 0
    AddCorner(accent, 4)
    accent.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Position          = UDim2.fromOffset(14, 10)
    titleLbl.Size              = UDim2.new(1, -50, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text              = title
    titleLbl.TextColor3        = theme.TextPrimary
    titleLbl.TextSize          = 13
    titleLbl.Font              = Enum.Font.GothamBold
    titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
    titleLbl.Parent            = card

    local msgLbl = Instance.new("TextLabel")
    msgLbl.Position          = UDim2.fromOffset(14, 30)
    msgLbl.Size              = UDim2.new(1, -20, 0, 28)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text              = message
    msgLbl.TextColor3        = theme.TextSecondary
    msgLbl.TextSize          = 12
    msgLbl.Font              = Enum.Font.Gotham
    msgLbl.TextXAlignment    = Enum.TextXAlignment.Left
    msgLbl.TextWrapped       = true
    msgLbl.Parent            = card

    -- Progress bar
    local prog = Instance.new("Frame")
    prog.Position          = UDim2.new(0, 0, 1, -2)
    prog.Size              = UDim2.new(1, 0, 0, 2)
    prog.BackgroundColor3  = accentColor
    prog.BorderSizePixel   = 0
    prog.Parent            = card

    card.Parent = NotifContainer

    -- Slide in
    card.Position = UDim2.fromOffset(310, 0)
    TweenQuick(card, {Position = UDim2.fromOffset(0, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Progress shrink
    Tween(prog, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})

    task.delay(duration, function()
        TweenQuick(card, {Position = UDim2.fromOffset(310, 0)}, 0.25)
        task.delay(0.3, function()
            card:Destroy()
        end)
    end)
end

-- ============================================================
--  RADIAL MENU
-- ============================================================
local function CreateRadialMenu(screenGui, items, theme, callback)
    items = items or {}
    local count = #items
    if count == 0 then return end

    local overlay = Instance.new("Frame")
    overlay.Size             = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BorderSizePixel  = 0
    overlay.ZIndex           = 80
    overlay.Parent           = screenGui

    local center = Instance.new("Frame")
    center.Size             = UDim2.fromOffset(320, 320)
    center.AnchorPoint      = Vector2.new(0.5, 0.5)
    center.Position         = UDim2.new(0.5, 0, 0.5, 0)
    center.BackgroundTransparency = 1
    center.ZIndex           = 81
    center.Parent           = overlay

    -- Center dot
    local dot = Instance.new("Frame")
    dot.Size            = UDim2.fromOffset(16, 16)
    dot.AnchorPoint     = Vector2.new(0.5, 0.5)
    dot.Position        = UDim2.new(0.5, 0, 0.5, 0)
    dot.BackgroundColor3 = theme.Accent
    dot.BorderSizePixel = 0
    AddCorner(dot, 8)
    dot.ZIndex = 82
    dot.Parent = center

    local angleStep = (2 * math.pi) / count
    local radius    = 120
    local buttons   = {}

    for i, item in ipairs(items) do
        local angle  = angleStep * (i - 1) - math.pi / 2
        local bx     = math.cos(angle) * radius
        local by     = math.sin(angle) * radius

        local btn = Instance.new("Frame")
        btn.Size            = UDim2.fromOffset(90, 40)
        btn.AnchorPoint     = Vector2.new(0.5, 0.5)
        btn.Position        = UDim2.new(0.5, bx, 0.5, by)
        btn.BackgroundColor3 = theme.SurfaceVariant
        btn.BorderSizePixel = 0
        btn.ZIndex          = 82
        AddCorner(btn, 8)
        AddStroke(btn, theme.Border, 1, 0.5)

        local btnLbl = Instance.new("TextLabel")
        btnLbl.Size             = UDim2.new(1, -8, 1, 0)
        btnLbl.Position         = UDim2.fromOffset(4, 0)
        btnLbl.BackgroundTransparency = 1
        btnLbl.Text             = item.Title or ("Item " .. i)
        btnLbl.TextColor3       = theme.TextPrimary
        btnLbl.TextSize         = 12
        btnLbl.Font             = Enum.Font.GothamMedium
        btnLbl.ZIndex           = 83
        btnLbl.Parent           = btn

        -- Scale in
        btn.Size = UDim2.fromOffset(0, 0)
        TweenQuick(btn, {Size = UDim2.fromOffset(90, 40)}, 0.2 + (i - 1) * 0.04, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        local detector = Instance.new("TextButton")
        detector.Size               = UDim2.new(1, 0, 1, 0)
        detector.BackgroundTransparency = 1
        detector.Text               = ""
        detector.ZIndex             = 84
        detector.Parent             = btn

        detector.MouseEnter:Connect(function()
            TweenQuick(btn, {BackgroundColor3 = theme.Accent}, 0.15)
            TweenQuick(btnLbl, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
        end)
        detector.MouseLeave:Connect(function()
            TweenQuick(btn, {BackgroundColor3 = theme.SurfaceVariant}, 0.15)
            TweenQuick(btnLbl, {TextColor3 = theme.TextPrimary}, 0.15)
        end)
        detector.MouseButton1Click:Connect(function()
            if item.Callback then item.Callback() end
            if callback then callback(item.Title, i) end
            TweenQuick(overlay, {BackgroundTransparency = 1}, 0.2)
            task.delay(0.2, function() overlay:Destroy() end)
        end)

        table.insert(buttons, btn)
        btn.Parent = center
    end

    -- Close on overlay click
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size               = UDim2.new(1, 0, 1, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text               = ""
    closeBtn.ZIndex             = 79
    closeBtn.Parent             = overlay

    closeBtn.MouseButton1Click:Connect(function()
        TweenQuick(overlay, {BackgroundTransparency = 1}, 0.2)
        task.delay(0.2, function() overlay:Destroy() end)
    end)
end

-- ============================================================
--  MAIN LIBRARY CONSTRUCTOR
-- ============================================================
function NexusUI:Window(config)
    config = config or {}

    local themeName  = config.Theme  or "Dark"
    local theme      = Themes[themeName] or Themes.Dark
    local accentClr  = config.Accent or theme.Accent
    theme = table.clone(theme)
    theme.Accent    = accentClr
    theme.AccentDim = Color3.fromRGB(
        math.floor(accentClr.R * 255 * 0.6),
        math.floor(accentClr.G * 255 * 0.6),
        math.floor(accentClr.B * 255 * 0.6)
    )

    local title      = config.Title  or "NexusUI"
    local size       = config.Size   or UDim2.fromOffset(520, 420)
    local minSize    = config.MinSize or UDim2.fromOffset(200, 50)

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name             = "NexusUI_" .. title:gsub("%s", "_")
    screenGui.ResetOnSpawn     = false
    screenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder     = 10
    screenGui.IgnoreGuiInset   = true
    screenGui.Parent           = LocalPlayer:WaitForChild("PlayerGui")

    InitTooltip(screenGui, theme)
    InitNotifications(screenGui, theme)

    -- -------------------------------------------------------
    --  MAIN WINDOW FRAME
    -- -------------------------------------------------------
    local windowFrame = Instance.new("Frame")
    windowFrame.Name             = "WindowFrame"
    windowFrame.Size             = size
    windowFrame.Position         = UDim2.new(0.5, -(size.X.Offset / 2), 0.5, -(size.Y.Offset / 2))
    windowFrame.BackgroundColor3 = theme.Background
    windowFrame.BorderSizePixel  = 0
    windowFrame.ClipsDescendants = true
    AddCorner(windowFrame, 12)
    AddStroke(windowFrame, theme.Border, 1, 0.5)
    windowFrame.Parent = screenGui

    -- Subtle top gradient
    local topGradient = Instance.new("Frame")
    topGradient.Size             = UDim2.new(1, 0, 0, 2)
    topGradient.BackgroundColor3 = accentClr
    topGradient.BorderSizePixel  = 0
    topGradient.ZIndex           = 2
    topGradient.Parent           = windowFrame
    AddGradient(topGradient, accentClr, Color3.fromRGB(accentClr.R*255*0.4, accentClr.G*255*0.4, accentClr.B*255*0.4), 90)

    -- -------------------------------------------------------
    --  TITLE BAR
    -- -------------------------------------------------------
    local titleBar = Instance.new("Frame")
    titleBar.Name             = "TitleBar"
    titleBar.Size             = UDim2.new(1, 0, 0, 44)
    titleBar.Position         = UDim2.fromOffset(0, 2)
    titleBar.BackgroundColor3 = theme.Surface
    titleBar.BorderSizePixel  = 0
    titleBar.ZIndex           = 3
    titleBar.Parent           = windowFrame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Position          = UDim2.fromOffset(14, 0)
    titleLbl.Size              = UDim2.new(1, -120, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text              = title
    titleLbl.TextColor3        = theme.TextPrimary
    titleLbl.TextSize          = 15
    titleLbl.Font              = Enum.Font.GothamBold
    titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
    titleLbl.ZIndex            = 4
    titleLbl.Parent            = titleBar

    -- Separator line
    local sep = Instance.new("Frame")
    sep.Size             = UDim2.new(1, 0, 0, 1)
    sep.Position         = UDim2.new(0, 0, 1, 0)
    sep.BackgroundColor3 = theme.Border
    sep.BorderSizePixel  = 0
    sep.ZIndex           = 3
    sep.Parent           = titleBar

    -- -------------------------------------------------------
    --  TITLE BAR BUTTONS (Close / Minimize)
    -- -------------------------------------------------------
    local function MakeTitleButton(offsetX, bgColor, labelText)
        local btn = Instance.new("Frame")
        btn.Size             = UDim2.fromOffset(14, 14)
        btn.AnchorPoint      = Vector2.new(0, 0.5)
        btn.Position         = UDim2.new(1, offsetX, 0.5, 0)
        btn.BackgroundColor3 = bgColor
        btn.BorderSizePixel  = 0
        btn.ZIndex           = 5
        AddCorner(btn, 7)

        local lbl = Instance.new("TextLabel")
        lbl.Size               = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = labelText
        lbl.TextColor3         = Color3.fromRGB(0,0,0)
        lbl.TextSize           = 10
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextTransparency   = 0.4
        lbl.ZIndex             = 6
        lbl.Visible            = false
        lbl.Parent             = btn

        local detector = Instance.new("TextButton")
        detector.Size               = UDim2.new(1, 0, 1, 0)
        detector.BackgroundTransparency = 1
        detector.Text               = ""
        detector.ZIndex             = 7
        detector.Parent             = btn

        detector.MouseEnter:Connect(function()
            lbl.Visible = true
            TweenQuick(btn, {Size = UDim2.fromOffset(16, 16)}, 0.12)
        end)
        detector.MouseLeave:Connect(function()
            lbl.Visible = false
            TweenQuick(btn, {Size = UDim2.fromOffset(14, 14)}, 0.12)
        end)

        btn.Parent = titleBar
        return btn, detector
    end

    local closeBtn, closeDetector   = MakeTitleButton(-18, Color3.fromRGB(255, 80, 80), "x")
    local minimizeBtn, minDetector  = MakeTitleButton(-40, Color3.fromRGB(255, 190, 50), "-")

    local minimized = false
    local storedHeight = size.Y.Offset

    minDetector.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            storedHeight = windowFrame.AbsoluteSize.Y
            TweenQuick(windowFrame, {Size = UDim2.new(0, windowFrame.AbsoluteSize.X, 0, 46)}, 0.3, Enum.EasingStyle.Quart)
        else
            TweenQuick(windowFrame, {Size = UDim2.fromOffset(windowFrame.AbsoluteSize.X, storedHeight)}, 0.3, Enum.EasingStyle.Back)
        end
    end)

    closeDetector.MouseButton1Click:Connect(function()
        TweenQuick(windowFrame, {Size = UDim2.fromOffset(windowFrame.AbsoluteSize.X, 0)}, 0.25)
        task.delay(0.25, function()
            screenGui:Destroy()
        end)
    end)

    -- -------------------------------------------------------
    --  DRAG SYSTEM
    -- -------------------------------------------------------
    do
        local dragging = false
        local dragStart, startPos

        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging  = true
                dragStart = input.Position
                startPos  = windowFrame.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                             input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                windowFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- -------------------------------------------------------
    --  TAB SYSTEM
    -- -------------------------------------------------------
    local tabBar = Instance.new("Frame")
    tabBar.Name             = "TabBar"
    tabBar.Size             = UDim2.new(1, 0, 0, 36)
    tabBar.Position         = UDim2.fromOffset(0, 46)
    tabBar.BackgroundColor3 = theme.SurfaceVariant
    tabBar.BorderSizePixel  = 0
    tabBar.ZIndex           = 3
    tabBar.ClipsDescendants = true
    tabBar.Parent           = windowFrame

    local tabBarLayout = Instance.new("UIListLayout")
    tabBarLayout.FillDirection  = Enum.FillDirection.Horizontal
    tabBarLayout.SortOrder      = Enum.SortOrder.LayoutOrder
    tabBarLayout.Padding        = UDim.new(0, 2)
    tabBarLayout.Parent         = tabBar
    AddPadding(tabBar, 4, 4, 6, 6)

    local tabSep = Instance.new("Frame")
    tabSep.Size             = UDim2.new(1, 0, 0, 1)
    tabSep.Position         = UDim2.new(0, 0, 1, 0)
    tabSep.BackgroundColor3 = theme.Border
    tabSep.BorderSizePixel  = 0
    tabSep.ZIndex           = 3
    tabSep.Parent           = tabBar

    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name             = "ContentArea"
    contentArea.Size             = UDim2.new(1, 0, 1, -83)
    contentArea.Position         = UDim2.fromOffset(0, 83)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel  = 0
    contentArea.ClipsDescendants = true
    contentArea.Parent           = windowFrame

    local tabs      = {}
    local activeTab = nil

    local function SelectTab(tabObj)
        if activeTab == tabObj then return end

        -- Deactivate old
        if activeTab then
            TweenQuick(activeTab._btn, {BackgroundColor3 = Color3.fromRGB(0,0,0)}, 0.15)
            TweenQuick(activeTab._btnLbl, {TextColor3 = theme.TextSecondary}, 0.15)
            activeTab._btn.BackgroundTransparency = 1
            activeTab._content.Visible = false
        end

        activeTab = tabObj
        activeTab._btn.BackgroundTransparency = 0
        TweenQuick(activeTab._btn, {BackgroundColor3 = theme.Accent}, 0.15)
        TweenQuick(activeTab._btnLbl, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
        activeTab._content.Visible = true
    end

    -- Window API Object
    local WindowAPI = {}

    -- -------------------------------------------------------
    --  WINDOW:Tab()
    -- -------------------------------------------------------
    function WindowAPI:Tab(tabTitle)
        local tabIndex = #tabs + 1

        -- Tab button
        local tabBtn = Instance.new("Frame")
        tabBtn.Name             = "Tab_" .. tabTitle
        tabBtn.Size             = UDim2.fromOffset(0, 28)
        tabBtn.AutomaticSize    = Enum.AutomaticSize.X
        tabBtn.BackgroundColor3 = theme.Accent
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel  = 0
        tabBtn.LayoutOrder      = tabIndex
        tabBtn.ZIndex           = 4
        AddCorner(tabBtn, 6)

        local tabBtnLbl = Instance.new("TextLabel")
        tabBtnLbl.Size              = UDim2.new(1, 0, 1, 0)
        tabBtnLbl.BackgroundTransparency = 1
        tabBtnLbl.Text              = tabTitle
        tabBtnLbl.TextColor3        = theme.TextSecondary
        tabBtnLbl.TextSize          = 13
        tabBtnLbl.Font              = Enum.Font.GothamMedium
        tabBtnLbl.ZIndex            = 5
        tabBtnLbl.Parent            = tabBtn
        AddPadding(tabBtnLbl, 0, 0, 12, 12)

        local tabDet = Instance.new("TextButton")
        tabDet.Size               = UDim2.new(1, 0, 1, 0)
        tabDet.BackgroundTransparency = 1
        tabDet.Text               = ""
        tabDet.ZIndex             = 6
        tabDet.Parent             = tabBtn
        tabBtn.Parent = tabBar

        -- Tab content (scrolling frame)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name              = "TabContent_" .. tabTitle
        tabContent.Size              = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel   = 0
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = accentClr
        tabContent.ScrollBarImageTransparency = 0.3
        tabContent.CanvasSize        = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Visible           = false
        tabContent.ZIndex            = 3
        tabContent.Parent            = contentArea
        AddPadding(tabContent, 10, 10, 10, 10)

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder    = Enum.SortOrder.LayoutOrder
        contentLayout.Padding      = UDim.new(0, 8)
        contentLayout.Parent       = tabContent

        local tabObj = {
            _btn     = tabBtn,
            _btnLbl  = tabBtnLbl,
            _content = tabContent,
            _layout  = contentLayout,
            _index   = tabIndex,
        }
        table.insert(tabs, tabObj)

        tabDet.MouseButton1Click:Connect(function()
            SelectTab(tabObj)
        end)

        if tabIndex == 1 then
            SelectTab(tabObj)
        end

        -- -------------------------------------------------------
        --  TAB:Section()
        -- -------------------------------------------------------
        local TabAPI = {}

        function TabAPI:Section(sectionTitle)
            local sectionIndex = #tabContent:GetChildren()

            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name             = "Section_" .. sectionTitle
            sectionFrame.Size             = UDim2.new(1, 0, 0, 0)
            sectionFrame.AutomaticSize    = Enum.AutomaticSize.Y
            sectionFrame.BackgroundColor3 = theme.SurfaceVariant
            sectionFrame.BorderSizePixel  = 0
            sectionFrame.LayoutOrder      = sectionIndex
            AddCorner(sectionFrame, 10)
            AddStroke(sectionFrame, theme.Border, 1, 0.6)

            local sectionHeader = Instance.new("Frame")
            sectionHeader.Name             = "SectionHeader"
            sectionHeader.Size             = UDim2.new(1, 0, 0, 34)
            sectionHeader.BackgroundColor3 = theme.SectionHeader
            sectionHeader.BorderSizePixel  = 0
            AddCorner(sectionHeader, 10)

            local sectionTitle2 = Instance.new("TextLabel")
            sectionTitle2.Position          = UDim2.fromOffset(14, 0)
            sectionTitle2.Size              = UDim2.new(1, -14, 1, 0)
            sectionTitle2.BackgroundTransparency = 1
            sectionTitle2.Text              = sectionTitle
            sectionTitle2.TextColor3        = accentClr
            sectionTitle2.TextSize          = 12
            sectionTitle2.Font              = Enum.Font.GothamBold
            sectionTitle2.TextXAlignment    = Enum.TextXAlignment.Left
            sectionTitle2.ZIndex            = 2
            sectionTitle2.Parent            = sectionHeader

            sectionHeader.Parent = sectionFrame

            local componentHolder = Instance.new("Frame")
            componentHolder.Name             = "ComponentHolder"
            componentHolder.Size             = UDim2.new(1, 0, 0, 0)
            componentHolder.Position         = UDim2.fromOffset(0, 34)
            componentHolder.AutomaticSize    = Enum.AutomaticSize.Y
            componentHolder.BackgroundTransparency = 1
            componentHolder.BorderSizePixel  = 0
            componentHolder.Parent           = sectionFrame
            AddPadding(componentHolder, 6, 8, 10, 10)

            local compLayout = Instance.new("UIListLayout")
            compLayout.SortOrder = Enum.SortOrder.LayoutOrder
            compLayout.Padding   = UDim.new(0, 6)
            compLayout.Parent    = componentHolder

            sectionFrame.Parent = tabContent

            -- ===================================================
            --  SECTION COMPONENT HELPERS
            -- ===================================================
            local compIndex = 0
            local function nextIndex()
                compIndex = compIndex + 1
                return compIndex
            end

            -- Base component frame factory
            local function MakeComponentFrame(height)
                local f = Instance.new("Frame")
                f.Size             = UDim2.new(1, 0, 0, height or 40)
                f.BackgroundTransparency = 1
                f.BorderSizePixel  = 0
                f.LayoutOrder      = nextIndex()
                f.Parent           = componentHolder
                return f
            end

            -- Title + Description helper
            local function MakeTitleDesc(parent, t, desc, rightPad)
                rightPad = rightPad or 0
                local tLbl = Instance.new("TextLabel")
                tLbl.Position          = UDim2.fromOffset(0, 0)
                tLbl.Size              = UDim2.new(1, -rightPad, 0, 18)
                tLbl.BackgroundTransparency = 1
                tLbl.Text              = t or ""
                tLbl.TextColor3        = theme.TextPrimary
                tLbl.TextSize          = 13
                tLbl.Font              = Enum.Font.GothamMedium
                tLbl.TextXAlignment    = Enum.TextXAlignment.Left
                tLbl.Parent            = parent

                if desc and desc ~= "" then
                    local dLbl = Instance.new("TextLabel")
                    dLbl.Position          = UDim2.fromOffset(0, 20)
                    dLbl.Size              = UDim2.new(1, -rightPad, 0, 14)
                    dLbl.BackgroundTransparency = 1
                    dLbl.Text              = desc
                    dLbl.TextColor3        = theme.TextSecondary
                    dLbl.TextSize          = 11
                    dLbl.Font              = Enum.Font.Gotham
                    dLbl.TextXAlignment    = Enum.TextXAlignment.Left
                    dLbl.Parent            = parent
                    return tLbl, dLbl
                end
                return tLbl
            end

            local SectionAPI = {}

            -- -----------------------------------------------
            --  LABEL
            -- -----------------------------------------------
            function SectionAPI:Label(opts)
                opts = opts or {}
                local f = MakeComponentFrame(22)
                local lbl = MakeLabel(f, opts.Title or opts.Text or "", opts.Size or 13, opts.Color or theme.TextSecondary, opts.Font or Enum.Font.Gotham)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                return lbl
            end

            -- -----------------------------------------------
            --  BUTTON
            -- -----------------------------------------------
            function SectionAPI:Button(opts)
                opts = opts or {}
                local f = MakeComponentFrame(38)

                local btn = Instance.new("Frame")
                btn.Size             = UDim2.new(1, 0, 1, 0)
                btn.BackgroundColor3 = theme.Surface
                btn.BorderSizePixel  = 0
                AddCorner(btn, 8)
                AddStroke(btn, theme.Border, 1, 0.5)
                btn.Parent = f

                -- Accent glow bar
                local glowBar = Instance.new("Frame")
                glowBar.Size            = UDim2.new(0, 3, 0.7, 0)
                glowBar.AnchorPoint     = Vector2.new(0, 0.5)
                glowBar.Position        = UDim2.new(0, 0, 0.5, 0)
                glowBar.BackgroundColor3 = accentClr
                glowBar.BorderSizePixel = 0
                AddCorner(glowBar, 2)
                glowBar.Parent = btn

                local lbl = Instance.new("TextLabel")
                lbl.Position          = UDim2.fromOffset(14, 0)
                lbl.Size              = UDim2.new(1, -60, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text              = opts.Title or "Button"
                lbl.TextColor3        = theme.TextPrimary
                lbl.TextSize          = 13
                lbl.Font              = Enum.Font.GothamMedium
                lbl.TextXAlignment    = Enum.TextXAlignment.Left
                lbl.Parent            = btn

                if opts.Description and opts.Description ~= "" then
                    lbl.Position  = UDim2.fromOffset(14, -7)
                    local desc = MakeLabel(btn, opts.Description, 11, theme.TextSecondary, Enum.Font.Gotham)
                    desc.Position = UDim2.fromOffset(14, 18)
                    desc.Size     = UDim2.new(1, -70, 0, 14)
                end

                local detector = Instance.new("TextButton")
                detector.Size               = UDim2.new(1, 0, 1, 0)
                detector.BackgroundTransparency = 1
                detector.Text               = ""
                detector.Parent             = btn

                detector.MouseEnter:Connect(function()
                    TweenQuick(btn, {BackgroundColor3 = theme.SurfaceVariant}, 0.15)
                    ShowTooltip(opts.Tooltip or "")
                end)
                detector.MouseLeave:Connect(function()
                    TweenQuick(btn, {BackgroundColor3 = theme.Surface}, 0.15)
                    HideTooltip()
                end)
                detector.MouseButton1Down:Connect(function()
                    TweenQuick(btn, {BackgroundColor3 = theme.AccentDim}, 0.1)
                end)
                detector.MouseButton1Up:Connect(function()
                    TweenQuick(btn, {BackgroundColor3 = theme.SurfaceVariant}, 0.15)
                end)
                detector.MouseButton1Click:Connect(function()
                    if opts.Callback then opts.Callback() end
                end)

                return detector
            end

            -- -----------------------------------------------
            --  TOGGLE
            -- -----------------------------------------------
            function SectionAPI:Toggle(opts)
                opts = opts or {}
                local value = opts.Default or false

                local f = MakeComponentFrame(opts.Description and 50 or 38)
                local titleLbl, descLbl = MakeTitleDesc(f, opts.Title or "Toggle", opts.Description, 60)

                -- Track
                local track = Instance.new("Frame")
                track.Size            = UDim2.fromOffset(44, 24)
                track.AnchorPoint     = Vector2.new(1, 0.5)
                track.Position        = UDim2.new(1, 0, 0.5, 0)
                track.BackgroundColor3 = value and accentClr or theme.SliderTrack
                track.BorderSizePixel = 0
                AddCorner(track, 12)

                -- Glow effect
                local glow = Instance.new("Frame")
                glow.Size              = UDim2.new(1, 0, 1, 0)
                glow.BackgroundColor3  = accentClr
                glow.BackgroundTransparency = value and 0.7 or 1
                glow.BorderSizePixel   = 0
                AddCorner(glow, 12)
                glow.Parent = track

                -- Thumb
                local thumb = Instance.new("Frame")
                thumb.Size             = UDim2.fromOffset(18, 18)
                thumb.AnchorPoint      = Vector2.new(0, 0.5)
                thumb.Position         = value and UDim2.fromOffset(23, 12) or UDim2.fromOffset(3, 12)
                thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                thumb.BorderSizePixel  = 0
                AddCorner(thumb, 9)
                thumb.Parent = track
                track.Parent = f

                local detector = Instance.new("TextButton")
                detector.Size               = UDim2.new(1, 0, 1, 0)
                detector.BackgroundTransparency = 1
                detector.Text               = ""
                detector.Parent             = f

                detector.MouseEnter:Connect(function()
                    ShowTooltip(opts.Tooltip or "")
                end)
                detector.MouseLeave:Connect(function()
                    HideTooltip()
                end)

                detector.MouseButton1Click:Connect(function()
                    value = not value
                    TweenQuick(track, {BackgroundColor3 = value and accentClr or theme.SliderTrack}, 0.2)
                    TweenQuick(glow, {BackgroundTransparency = value and 0.7 or 1}, 0.2)
                    TweenQuick(thumb, {Position = value and UDim2.fromOffset(23, 12) or UDim2.fromOffset(3, 12)}, 0.2, Enum.EasingStyle.Back)
                    if opts.Callback then opts.Callback(value) end
                end)

                return {
                    Set = function(_, v)
                        value = v
                        TweenQuick(track, {BackgroundColor3 = value and accentClr or theme.SliderTrack}, 0.2)
                        TweenQuick(glow, {BackgroundTransparency = value and 0.7 or 1}, 0.2)
                        TweenQuick(thumb, {Position = value and UDim2.fromOffset(23, 12) or UDim2.fromOffset(3, 12)}, 0.2)
                    end,
                    Get = function(_) return value end,
                }
            end

            -- -----------------------------------------------
            --  CHECKBOX
            -- -----------------------------------------------
            function SectionAPI:Checkbox(opts)
                opts = opts or {}
                local value = opts.Default or false

                local f = MakeComponentFrame(opts.Description and 50 or 38)
                MakeTitleDesc(f, opts.Title or "Checkbox", opts.Description, 36)

                local box = Instance.new("Frame")
                box.Size             = UDim2.fromOffset(22, 22)
                box.AnchorPoint      = Vector2.new(1, 0.5)
                box.Position         = UDim2.new(1, 0, 0.5, 0)
                box.BackgroundColor3 = value and accentClr or theme.SliderTrack
                box.BorderSizePixel  = 0
                AddCorner(box, 5)
                AddStroke(box, value and accentClr or theme.Border, 1.5, 0)

                local check = Instance.new("TextLabel")
                check.Size               = UDim2.new(1, 0, 1, 0)
                check.BackgroundTransparency = 1
                check.Text               = "v"  -- checkmark using v
                check.TextColor3         = Color3.fromRGB(255, 255, 255)
                check.TextSize           = 13
                check.Font               = Enum.Font.GothamBold
                check.TextTransparency   = value and 0 or 1
                check.Parent             = box

                local detector = Instance.new("TextButton")
                detector.Size               = UDim2.new(1, 0, 1, 0)
                detector.BackgroundTransparency = 1
                detector.Text               = ""
                detector.Parent             = f

                detector.MouseButton1Click:Connect(function()
                    value = not value
                    TweenQuick(box, {BackgroundColor3 = value and accentClr or theme.SliderTrack}, 0.15)
                    TweenQuick(check, {TextTransparency = value and 0 or 1}, 0.15)
                    if opts.Callback then opts.Callback(value) end
                end)

                return {
                    Set = function(_, v)
                        value = v
                        TweenQuick(box, {BackgroundColor3 = value and accentClr or theme.SliderTrack}, 0.15)
                        TweenQuick(check, {TextTransparency = value and 0 or 1}, 0.15)
                    end,
                    Get = function(_) return value end,
                }
            end

            -- -----------------------------------------------
            --  SLIDER
            -- -----------------------------------------------
            function SectionAPI:Slider(opts)
                opts = opts or {}
                local minVal   = opts.Min     or 0
                local maxVal   = opts.Max     or 100
                local stepVal  = opts.Step    or 1
                local curVal   = opts.Default or minVal
                local suffix   = opts.Suffix  or ""

                local function clamp(v) return math.clamp(v, minVal, maxVal) end
                local function snap(v)
                    if stepVal <= 0 then return v end
                    return math.round((v - minVal) / stepVal) * stepVal + minVal
                end

                local f = MakeComponentFrame(56)

                -- Title row
                local titleRow = Instance.new("Frame")
                titleRow.Size             = UDim2.new(1, 0, 0, 18)
                titleRow.BackgroundTransparency = 1
                titleRow.Parent           = f

                local tLbl = MakeLabel(titleRow, opts.Title or "Slider", 13, theme.TextPrimary, Enum.Font.GothamMedium)
                tLbl.Size = UDim2.new(1, -70, 1, 0)

                local valLbl = Instance.new("TextLabel")
                valLbl.Size             = UDim2.fromOffset(65, 18)
                valLbl.AnchorPoint      = Vector2.new(1, 0)
                valLbl.Position         = UDim2.new(1, 0, 0, 0)
                valLbl.BackgroundTransparency = 1
                valLbl.Text             = tostring(curVal) .. suffix
                valLbl.TextColor3       = accentClr
                valLbl.TextSize         = 13
                valLbl.Font             = Enum.Font.GothamBold
                valLbl.TextXAlignment   = Enum.TextXAlignment.Right
                valLbl.Parent           = titleRow

                if opts.Description then
                    local dLbl = MakeLabel(f, opts.Description, 11, theme.TextSecondary)
                    dLbl.Position = UDim2.fromOffset(0, 18)
                    dLbl.Size     = UDim2.new(1, 0, 0, 14)
                end

                -- Track
                local trackFrame = Instance.new("Frame")
                trackFrame.Size             = UDim2.new(1, 0, 0, 6)
                trackFrame.Position         = UDim2.new(0, 0, 1, -10)
                trackFrame.BackgroundColor3 = theme.SliderTrack
                trackFrame.BorderSizePixel  = 0
                AddCorner(trackFrame, 3)
                trackFrame.Parent = f

                -- Fill
                local fillFrac = (curVal - minVal) / math.max(1, maxVal - minVal)
                local fillFrame = Instance.new("Frame")
                fillFrame.Size             = UDim2.new(fillFrac, 0, 1, 0)
                fillFrame.BackgroundColor3 = accentClr
                fillFrame.BorderSizePixel  = 0
                AddCorner(fillFrame, 3)
                fillFrame.Parent = trackFrame

                -- Knob
                local knob = Instance.new("Frame")
                knob.Size             = UDim2.fromOffset(16, 16)
                knob.AnchorPoint      = Vector2.new(0.5, 0.5)
                knob.Position         = UDim2.new(fillFrac, 0, 0.5, 0)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel  = 0
                AddCorner(knob, 8)
                AddStroke(knob, accentClr, 2, 0)
                knob.Parent = trackFrame

                local dragging = false

                local function updateSlider(mouseX)
                    local abs = trackFrame.AbsolutePosition
                    local sz  = trackFrame.AbsoluteSize
                    local frac = math.clamp((mouseX - abs.X) / sz.X, 0, 1)
                    local raw  = minVal + (maxVal - minVal) * frac
                    curVal = clamp(snap(raw))
                    local displayFrac = (curVal - minVal) / math.max(1, maxVal - minVal)
                    TweenQuick(fillFrame, {Size = UDim2.new(displayFrac, 0, 1, 0)}, 0.05)
                    TweenQuick(knob, {Position = UDim2.new(displayFrac, 0, 0.5, 0)}, 0.05)
                    valLbl.Text = tostring(curVal) .. suffix
                    if opts.Callback then opts.Callback(curVal) end
                end

                local det = Instance.new("TextButton")
                det.Size               = UDim2.new(1, 0, 0, 24)
                det.Position           = UDim2.new(0, 0, 1, -22)
                det.BackgroundTransparency = 1
                det.Text               = ""
                det.Parent             = f

                det.MouseButton1Down:Connect(function()
                    dragging = true
                    TweenQuick(knob, {Size = UDim2.fromOffset(20, 20)}, 0.1)
                    updateSlider(Mouse.X)
                end)
                det.MouseEnter:Connect(function() ShowTooltip(opts.Tooltip or "") end)
                det.MouseLeave:Connect(function() HideTooltip() end)

                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(Mouse.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        if dragging then
                            dragging = false
                            TweenQuick(knob, {Size = UDim2.fromOffset(16, 16)}, 0.1)
                        end
                    end
                end)

                return {
                    Set = function(_, v)
                        curVal = clamp(snap(v))
                        local frac = (curVal - minVal) / math.max(1, maxVal - minVal)
                        fillFrame.Size = UDim2.new(frac, 0, 1, 0)
                        knob.Position  = UDim2.new(frac, 0, 0.5, 0)
                        valLbl.Text    = tostring(curVal) .. suffix
                    end,
                    Get = function(_) return curVal end,
                }
            end

            -- -----------------------------------------------
            --  DROPDOWN
            -- -----------------------------------------------
            function SectionAPI:Dropdown(opts)
                opts = opts or {}
                local options = opts.Options or {}
                local curSel  = opts.Default or (options[1] or "Select...")
                local isOpen  = false

                local f = MakeComponentFrame(38)
                MakeTitleDesc(f, opts.Title, opts.Description, 0)

                -- Main dropdown button
                local dropBtn = Instance.new("Frame")
                dropBtn.Size             = UDim2.new(1, 0, 0, 30)
                dropBtn.Position         = UDim2.fromOffset(0, opts.Title and (opts.Description and 36 or 20) or 0)
                dropBtn.BackgroundColor3 = theme.Surface
                dropBtn.BorderSizePixel  = 0
                AddCorner(dropBtn, 7)
                AddStroke(dropBtn, theme.Border, 1, 0.5)
                dropBtn.Parent = f

                if opts.Title then
                    f.Size = UDim2.new(1, 0, 0, opts.Description and 90 or 60)
                end

                local selLbl = Instance.new("TextLabel")
                selLbl.Position          = UDim2.fromOffset(10, 0)
                selLbl.Size              = UDim2.new(1, -36, 1, 0)
                selLbl.BackgroundTransparency = 1
                selLbl.Text              = curSel
                selLbl.TextColor3        = theme.TextPrimary
                selLbl.TextSize          = 13
                selLbl.Font              = Enum.Font.Gotham
                selLbl.TextXAlignment    = Enum.TextXAlignment.Left
                selLbl.Parent            = dropBtn

                local arrow = Instance.new("TextLabel")
                arrow.Size               = UDim2.fromOffset(24, 30)
                arrow.AnchorPoint        = Vector2.new(1, 0)
                arrow.Position           = UDim2.new(1, 0, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.Text               = "v"
                arrow.TextColor3         = theme.TextSecondary
                arrow.TextSize           = 11
                arrow.Font               = Enum.Font.GothamBold
                arrow.Parent             = dropBtn

                -- Dropdown list (spawned on open)
                local listFrame

                local function CloseDropdown()
                    if listFrame then
                        TweenQuick(listFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        task.delay(0.15, function()
                            if listFrame then listFrame:Destroy(); listFrame = nil end
                        end)
                        TweenQuick(arrow, {TextColor3 = theme.TextSecondary}, 0.15)
                        isOpen = false
                    end
                end

                local function OpenDropdown()
                    if isOpen then CloseDropdown(); return end
                    isOpen = true
                    TweenQuick(arrow, {TextColor3 = accentClr}, 0.15)

                    listFrame = Instance.new("ScrollingFrame")
                    listFrame.Size             = UDim2.new(1, 0, 0, 0)
                    listFrame.Position         = UDim2.new(0, 0, 1, 3)
                    listFrame.BackgroundColor3 = theme.Surface
                    listFrame.BorderSizePixel  = 0
                    listFrame.ZIndex           = 20
                    listFrame.ScrollBarThickness = 2
                    listFrame.ScrollBarImageColor3 = accentClr
                    listFrame.CanvasSize       = UDim2.new(0, 0, 0, 0)
                    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    AddCorner(listFrame, 7)
                    AddStroke(listFrame, theme.Border, 1, 0.4)
                    listFrame.Parent = dropBtn

                    local listLayout = Instance.new("UIListLayout")
                    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    listLayout.Parent    = listFrame
                    AddPadding(listFrame, 4, 4, 0, 0)

                    local targetH = math.min(#options * 32 + 10, 160)

                    for i, opt in ipairs(options) do
                        local item = Instance.new("Frame")
                        item.Size             = UDim2.new(1, 0, 0, 30)
                        item.BackgroundColor3 = opt == curSel and theme.SurfaceVariant or Color3.fromRGB(0,0,0)
                        item.BackgroundTransparency = opt == curSel and 0 or 1
                        item.BorderSizePixel  = 0
                        item.LayoutOrder      = i
                        item.ZIndex           = 21
                        AddCorner(item, 5)
                        item.Parent = listFrame

                        local itemLbl = Instance.new("TextLabel")
                        itemLbl.Position          = UDim2.fromOffset(10, 0)
                        itemLbl.Size              = UDim2.new(1, -10, 1, 0)
                        itemLbl.BackgroundTransparency = 1
                        itemLbl.Text              = opt
                        itemLbl.TextColor3        = opt == curSel and accentClr or theme.TextPrimary
                        itemLbl.TextSize          = 12
                        itemLbl.Font              = Enum.Font.Gotham
                        itemLbl.TextXAlignment    = Enum.TextXAlignment.Left
                        itemLbl.ZIndex            = 22
                        itemLbl.Parent            = item

                        local itemDet = Instance.new("TextButton")
                        itemDet.Size               = UDim2.new(1, 0, 1, 0)
                        itemDet.BackgroundTransparency = 1
                        itemDet.Text               = ""
                        itemDet.ZIndex             = 23
                        itemDet.Parent             = item

                        itemDet.MouseEnter:Connect(function()
                            TweenQuick(item, {BackgroundTransparency = 0, BackgroundColor3 = theme.SurfaceVariant}, 0.1)
                        end)
                        itemDet.MouseLeave:Connect(function()
                            TweenQuick(item, {BackgroundTransparency = opt == curSel and 0 or 1}, 0.1)
                        end)
                        itemDet.MouseButton1Click:Connect(function()
                            curSel = opt
                            selLbl.Text = opt
                            if opts.Callback then opts.Callback(opt) end
                            CloseDropdown()
                        end)
                    end

                    TweenQuick(listFrame, {Size = UDim2.new(1, 0, 0, targetH)}, 0.2, Enum.EasingStyle.Back)
                end

                local det = Instance.new("TextButton")
                det.Size               = UDim2.new(1, 0, 1, 0)
                det.BackgroundTransparency = 1
                det.Text               = ""
                det.Parent             = dropBtn

                det.MouseButton1Click:Connect(OpenDropdown)
                det.MouseEnter:Connect(function()
                    TweenQuick(dropBtn, {BackgroundColor3 = theme.SurfaceVariant}, 0.15)
                    ShowTooltip(opts.Tooltip or "")
                end)
                det.MouseLeave:Connect(function()
                    TweenQuick(dropBtn, {BackgroundColor3 = theme.Surface}, 0.15)
                    HideTooltip()
                end)

                return {
                    Set = function(_, v)
                        curSel = v
                        selLbl.Text = v
                    end,
                    Get = function(_) return curSel end,
                    SetOptions = function(_, newOpts)
                        options = newOpts
                        if not table.find(options, curSel) then
                            curSel = options[1] or ""
                            selLbl.Text = curSel
                        end
                    end,
                }
            end

            -- -----------------------------------------------
            --  RADIO GROUP
            -- -----------------------------------------------
            function SectionAPI:RadioGroup(opts)
                opts = opts or {}
                local options = opts.Options or {}
                local curSel  = opts.Default or options[1]

                local groupH = (#options * 30) + (opts.Title and 22 or 0) + 6
                local f = MakeComponentFrame(groupH)

                if opts.Title then
                    MakeLabel(f, opts.Title, 13, theme.TextPrimary, Enum.Font.GothamMedium)
                end

                local radioObjs = {}

                for i, opt in ipairs(options) do
                    local row = Instance.new("Frame")
                    row.Size             = UDim2.new(1, 0, 0, 28)
                    row.Position         = UDim2.fromOffset(0, (opts.Title and 22 or 0) + (i - 1) * 30)
                    row.BackgroundTransparency = 1
                    row.Parent           = f

                    local outerCircle = Instance.new("Frame")
                    outerCircle.Size            = UDim2.fromOffset(18, 18)
                    outerCircle.AnchorPoint     = Vector2.new(0, 0.5)
                    outerCircle.Position        = UDim2.fromOffset(0, 14)
                    outerCircle.BackgroundColor3 = opt == curSel and accentClr or theme.SliderTrack
                    outerCircle.BorderSizePixel = 0
                    AddCorner(outerCircle, 9)
                    AddStroke(outerCircle, opt == curSel and accentClr or theme.Border, 2, 0)
                    outerCircle.Parent = row

                    local innerDot = Instance.new("Frame")
                    innerDot.Size             = UDim2.fromOffset(8, 8)
                    innerDot.AnchorPoint      = Vector2.new(0.5, 0.5)
                    innerDot.Position         = UDim2.new(0.5, 0, 0.5, 0)
                    innerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    innerDot.BackgroundTransparency = opt == curSel and 0 or 1
                    innerDot.BorderSizePixel  = 0
                    AddCorner(innerDot, 4)
                    innerDot.Parent = outerCircle

                    local optLbl = MakeLabel(row, opt, 13, theme.TextPrimary)
                    optLbl.Position = UDim2.fromOffset(26, 0)
                    optLbl.Size     = UDim2.new(1, -26, 1, 0)

                    local det = Instance.new("TextButton")
                    det.Size               = UDim2.new(1, 0, 1, 0)
                    det.BackgroundTransparency = 1
                    det.Text               = ""
                    det.Parent             = row

                    table.insert(radioObjs, {outer = outerCircle, inner = innerDot, opt = opt})

                    det.MouseButton1Click:Connect(function()
                        curSel = opt
                        for _, ro in ipairs(radioObjs) do
                            local active = ro.opt == curSel
                            TweenQuick(ro.outer, {BackgroundColor3 = active and accentClr or theme.SliderTrack}, 0.15)
                            TweenQuick(ro.inner, {BackgroundTransparency = active and 0 or 1}, 0.15)
                        end
                        if opts.Callback then opts.Callback(opt) end
                    end)
                end

                return {
                    Get = function(_) return curSel end,
                    Set = function(_, v)
                        curSel = v
                        for _, ro in ipairs(radioObjs) do
                            local active = ro.opt == curSel
                            TweenQuick(ro.outer, {BackgroundColor3 = active and accentClr or theme.SliderTrack}, 0.15)
                            TweenQuick(ro.inner, {BackgroundTransparency = active and 0 or 1}, 0.15)
                        end
                    end,
                }
            end

            -- -----------------------------------------------
            --  TEXTBOX
            -- -----------------------------------------------
            function SectionAPI:Textbox(opts)
                opts = opts or {}
                local f = MakeComponentFrame(opts.Title and 60 or 38)
                if opts.Title then
                    MakeTitleDesc(f, opts.Title, opts.Description)
                end

                local boxFrame = Instance.new("Frame")
                boxFrame.Size             = UDim2.new(1, 0, 0, 32)
                boxFrame.Position         = UDim2.fromOffset(0, opts.Title and (opts.Description and 36 or 20) or 0)
                boxFrame.BackgroundColor3 = theme.Surface
                boxFrame.BorderSizePixel  = 0
                AddCorner(boxFrame, 7)
                AddStroke(boxFrame, theme.Border, 1, 0.5)

                local accentLine = Instance.new("Frame")
                accentLine.Size            = UDim2.new(0, 0, 0, 2)
                accentLine.Position        = UDim2.new(0, 0, 1, -2)
                accentLine.BackgroundColor3 = accentClr
                accentLine.BorderSizePixel = 0
                AddCorner(accentLine, 1)
                accentLine.Parent = boxFrame

                local tb = Instance.new("TextBox")
                tb.Size              = UDim2.new(1, -20, 1, 0)
                tb.Position          = UDim2.fromOffset(10, 0)
                tb.BackgroundTransparency = 1
                tb.Text              = opts.Default or ""
                tb.PlaceholderText   = opts.Placeholder or "Enter text..."
                tb.TextColor3        = theme.TextPrimary
                tb.PlaceholderColor3 = theme.TextMuted
                tb.TextSize          = 13
                tb.Font              = Enum.Font.Gotham
                tb.TextXAlignment    = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus  = opts.ClearOnFocus or false
                tb.Parent            = boxFrame

                boxFrame.Parent = f

                tb.Focused:Connect(function()
                    TweenQuick(accentLine, {Size = UDim2.new(1, 0, 0, 2)}, 0.2)
                    TweenQuick(boxFrame, {BackgroundColor3 = theme.SurfaceVariant}, 0.15)
                end)
                tb.FocusLost:Connect(function(entered)
                    TweenQuick(accentLine, {Size = UDim2.new(0, 0, 0, 2)}, 0.2)
                    TweenQuick(boxFrame, {BackgroundColor3 = theme.Surface}, 0.15)
                    if opts.Callback then opts.Callback(tb.Text, entered) end
                end)

                return {
                    Get  = function(_) return tb.Text end,
                    Set  = function(_, v) tb.Text = v end,
                    Clear = function(_) tb.Text = "" end,
                }
            end

            -- -----------------------------------------------
            --  KEYBIND
            -- -----------------------------------------------
            function SectionAPI:Keybind(opts)
                opts = opts or {}
                local curKey = opts.Default or Enum.KeyCode.Unknown
                local listening = false

                local f = MakeComponentFrame(opts.Description and 50 or 38)
                MakeTitleDesc(f, opts.Title or "Keybind", opts.Description, 80)

                local bindBtn = Instance.new("Frame")
                bindBtn.Size             = UDim2.fromOffset(72, 26)
                bindBtn.AnchorPoint      = Vector2.new(1, 0.5)
                bindBtn.Position         = UDim2.new(1, 0, 0.5, 0)
                bindBtn.BackgroundColor3 = theme.SurfaceVariant
                bindBtn.BorderSizePixel  = 0
                AddCorner(bindBtn, 6)
                AddStroke(bindBtn, theme.Border, 1, 0.5)

                local keyLbl = Instance.new("TextLabel")
                keyLbl.Size               = UDim2.new(1, 0, 1, 0)
                keyLbl.BackgroundTransparency = 1
                keyLbl.Text               = curKey.Name ~= "Unknown" and curKey.Name or "None"
                keyLbl.TextColor3         = theme.TextPrimary
                keyLbl.TextSize           = 12
                keyLbl.Font               = Enum.Font.GothamMedium
                keyLbl.Parent             = bindBtn

                local det = Instance.new("TextButton")
                det.Size               = UDim2.new(1, 0, 1, 0)
                det.BackgroundTransparency = 1
                det.Text               = ""
                det.Parent             = bindBtn
                bindBtn.Parent = f

                det.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    keyLbl.Text      = "..."
                    keyLbl.TextColor3 = accentClr
                    TweenQuick(bindBtn, {BackgroundColor3 = theme.AccentDim}, 0.15)

                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, processed)
                        if processed then return end
                        if inp.UserInputType == Enum.UserInputType.Keyboard then
                            curKey = inp.KeyCode
                            keyLbl.Text      = curKey.Name
                            keyLbl.TextColor3 = theme.TextPrimary
                            TweenQuick(bindBtn, {BackgroundColor3 = theme.SurfaceVariant}, 0.15)
                            listening = false
                            conn:Disconnect()

                            -- Register in keybind system
                            if opts.RegisterGlobal then
                                RegisterKeybind(curKey.Name, function()
                                    if opts.Callback then opts.Callback(curKey) end
                                end)
                            end
                            if opts.Callback then opts.Callback(curKey) end
                        end
                    end)
                end)

                return {
                    Get = function(_) return curKey end,
                    Set = function(_, v)
                        curKey = v
                        keyLbl.Text = v.Name
                    end,
                }
            end

            -- -----------------------------------------------
            --  SCROLLING CONTAINER
            -- -----------------------------------------------
            function SectionAPI:ScrollContainer(opts)
                opts = opts or {}
                local height = opts.Height or 120

                local f = MakeComponentFrame(height + (opts.Title and 22 or 0))
                if opts.Title then
                    MakeTitleDesc(f, opts.Title)
                end

                local scrollF = Instance.new("ScrollingFrame")
                scrollF.Size             = UDim2.new(1, 0, 0, height)
                scrollF.Position         = UDim2.fromOffset(0, opts.Title and 22 or 0)
                scrollF.BackgroundColor3 = theme.Background
                scrollF.BorderSizePixel  = 0
                scrollF.ScrollBarThickness = 3
                scrollF.ScrollBarImageColor3 = accentClr
                scrollF.CanvasSize       = UDim2.new(0, 0, 0, 0)
                scrollF.AutomaticCanvasSize = Enum.AutomaticSize.Y
                AddCorner(scrollF, 6)
                AddStroke(scrollF, theme.Border, 1, 0.6)
                scrollF.Parent = f
                AddPadding(scrollF, 6, 6, 6, 6)

                local layout = Instance.new("UIListLayout")
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Padding   = UDim.new(0, 4)
                layout.Parent    = scrollF

                return scrollF
            end

            -- -----------------------------------------------
            --  COLOR PICKER (Bonus)
            -- -----------------------------------------------
            function SectionAPI:ColorPicker(opts)
                opts = opts or {}
                local curColor = opts.Default or Color3.fromRGB(255, 255, 255)

                local f = MakeComponentFrame(opts.Description and 50 or 38)
                MakeTitleDesc(f, opts.Title or "Color", opts.Description, 42)

                local swatch = Instance.new("Frame")
                swatch.Size             = UDim2.fromOffset(34, 26)
                swatch.AnchorPoint      = Vector2.new(1, 0.5)
                swatch.Position         = UDim2.new(1, 0, 0.5, 0)
                swatch.BackgroundColor3 = curColor
                swatch.BorderSizePixel  = 0
                AddCorner(swatch, 6)
                AddStroke(swatch, theme.Border, 1, 0.4)
                swatch.Parent = f

                local det = Instance.new("TextButton")
                det.Size               = UDim2.new(1, 0, 1, 0)
                det.BackgroundTransparency = 1
                det.Text               = ""
                det.Parent             = f

                det.MouseEnter:Connect(function()
                    TweenQuick(swatch, {Size = UDim2.fromOffset(38, 28)}, 0.1)
                end)
                det.MouseLeave:Connect(function()
                    TweenQuick(swatch, {Size = UDim2.fromOffset(34, 26)}, 0.1)
                end)

                return {
                    Set = function(_, c)
                        curColor = c
                        swatch.BackgroundColor3 = c
                    end,
                    Get = function(_) return curColor end,
                }
            end

            -- Return SectionAPI
            return SectionAPI
        end

        -- -------------------------------------------------------
        --  TAB:Notify() pass-through
        -- -------------------------------------------------------
        function TabAPI:Notify(opts)
            Notify(opts, theme)
        end

        function TabAPI:RadialMenu(items, callback)
            CreateRadialMenu(screenGui, items, theme, callback)
        end

        return TabAPI
    end

    -- -------------------------------------------------------
    --  WINDOW LEVEL UTILITIES
    -- -------------------------------------------------------
    function WindowAPI:Notify(opts)
        Notify(opts, theme)
    end

    function WindowAPI:RadialMenu(items, callback)
        CreateRadialMenu(screenGui, items, theme, callback)
    end

    function WindowAPI:SetTheme(newThemeName)
        -- Dynamic theme switching (rebuilds colors)
        local newTheme = Themes[newThemeName]
        if not newTheme then return end
        theme = table.clone(newTheme)
        theme.Accent = accentClr
        windowFrame.BackgroundColor3 = theme.Background
        titleBar.BackgroundColor3    = theme.Surface
    end

    function WindowAPI:SetAccent(color)
        accentClr = color
        theme.Accent = color
        topGradient.BackgroundColor3 = color
    end

    function WindowAPI:Destroy()
        screenGui:Destroy()
    end

    -- Animate in
    windowFrame.Size = UDim2.fromOffset(size.X.Offset, 0)
    TweenQuick(windowFrame, {Size = size}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return WindowAPI
end

-- ============================================================
--  LIBRARY ENTRY POINT
-- ============================================================
local Library = {}
Library.__index = Library

setmetatable(Library, {
    __call = function(self, ...) return self end
})

function Library:Window(config)
    return NexusUI:Window(config)
end

function Library:Notify(opts)
    -- Standalone notify (needs a window initialized first for container)
    -- Fallback: create a temp screenGui
    warn("NexusUI: Use Window:Notify() or Tab:Notify() for notifications.")
end

function Library:RegisterKeybind(key, callback)
    RegisterKeybind(key, callback)
end

function Library:GetThemes()
    return {"Dark", "Light"}
end

-- ============================================================
--  USAGE EXAMPLE (commented out - remove to test)
-- ============================================================
--[[
local ui = Library

local window = ui:Window({
    Title  = "NexusUI Demo",
    Size   = UDim2.fromOffset(520, 460),
    Theme  = "Dark",
    Accent = Color3.fromRGB(0, 170, 255)
})

local mainTab = window:Tab("Main")
local section = mainTab:Section("Controls")

section:Toggle({
    Title       = "Auto Farm",
    Description = "Automatically farms resources",
    Default     = false,
    Callback    = function(value)
        print("Auto Farm:", value)
    end
})

section:Slider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 100,
    Default  = 16,
    Step     = 1,
    Suffix   = " stud/s",
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

section:Dropdown({
    Title    = "Aura",
    Options  = {"None", "Fire", "Ice", "Lightning", "Shadow"},
    Default  = "None",
    Callback = function(value)
        print("Aura:", value)
    end
})

section:Button({
    Title       = "Teleport to Spawn",
    Description = "Instantly move to spawn",
    Callback    = function()
        print("Teleporting...")
    end
})

section:Keybind({
    Title   = "Open Menu",
    Default = Enum.KeyCode.RightShift,
    RegisterGlobal = true,
    Callback = function(key)
        print("Keybind pressed:", key.Name)
    end
})

local settingsTab = window:Tab("Settings")
local settingsSection = settingsTab:Section("Appearance")

settingsSection:Checkbox({
    Title    = "Show FPS Counter",
    Default  = true,
    Callback = function(v) print("FPS Counter:", v) end
})

settingsSection:RadioGroup({
    Title    = "Theme",
    Options  = {"Dark", "Light", "System"},
    Default  = "Dark",
    Callback = function(v)
        if v == "Dark" then window:SetTheme("Dark")
        elseif v == "Light" then window:SetTheme("Light") end
    end
})

settingsSection:Textbox({
    Title       = "Username Override",
    Placeholder = "Enter username...",
    Callback    = function(text, entered)
        if entered then print("Username set to:", text) end
    end
})

window:Notify({
    Title   = "NexusUI Loaded",
    Message = "Welcome! Use the tabs to explore the demo.",
    Type    = "Success",
    Duration = 5,
})
--]]

return Library
