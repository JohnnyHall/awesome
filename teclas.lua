---------------- importing libraries ----------------
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library
local gears = require("gears") -- Utilities such as color parsing and objects
local awful = require("awful") -- Everything related to window managment
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 100

local lain = require("lain")
local freedesktop = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

------------------------------------------------
local my_table = awful.util.table or gears.table
------------------------------------------------


----------------------------------------------------
modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"

terminal = "alacritty"
browser = "firefox" --"qutebrowser"
editor = "vim"
emacs = "emacsclient -c -a 'emacs' "
mediaplayer = "mpv"
soundplayer = "ffplay -nodisp -autoexit "
----------------------------------------------------

globalkeys = my_table.join(

--------------------------------------------------------------------------------------
--                                AWESOME                                
--------------------------------------------------------------------------------------

-- modkey + enter = launch terminal
awful.key({modkey}, "Return", function()
    awful.spawn(terminal)
end, {
    description = "launch terminal",
    group = "awesome"
}), 

-- modkey + "b" = launch browser
awful.key({modkey}, "b", function()
    awful.spawn(browser)
end, {
    description = "launch browser",
    group = "awesome"
}), 

-- modkey + "r" = laurnch rofi
awful.key({modkey}, "r", function()
    awful.spawn("rofi -show")
end, {
    description = "launch rofi",
    group = "rofi"
}), 

-- modkey + shift + "r" = reload awesome
awful.key({modkey, "Shift"}, "r", awesome.restart, {
    description = "reload awesome",
    group = "awesome"
}), 

-- modkey + shift + "q" = quit awesome
awful.key({modkey, "Shift"}, "q", function()
    awful.spawn.with_shell("dm-logout")
end, {
    description = "quit awesome",
    group = "awesome"
}), 

-- modkey + "s" = show help
awful.key({modkey}, "s", hotkeys_popup.show_help, {
    description = "show help",
    group = "awesome"
}),

-- modkey + "Shift" + "w" = show main menu
awful.key({modkey, "Shift"}, "w", function()
    awful.util.mymainmenu:show()
end, {
    description = "show main menu",
    group = "awesome"
}),

-- modkey + shift + "b" = show/hide wibox
awful.key({modkey, "Shift"}, "b", function()
    for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        if s.mybottomwibox then
            s.mybottomwibox.visible = not s.mybottomwibox.visible
        end
    end
end, {
    description = "show/hide wibox",
    group = "awesome"
}),

--------------------------------------------------------------------------------------
--                                XBACKLIGHT                                
--------------------------------------------------------------------------------------

-- modkey + "F2" = decrease brightness
awful.key({modkey}, "F2", function()
    awful.spawn("xbacklight -dec 1")
end, {
    description = "decrease brightness",
    group = "xbacklight"
}), 

-- modkey + "F3" = increase brightness
awful.key({modkey}, "F3", function()
    awful.spawn("xbacklight -inc 1")
end, {
    description = "increase brightness",
    group = "xbacklight"
}), 

--------------------------------------------------------------------------------------
--                                TAG                                
--------------------------------------------------------------------------------------

-- Tag browsing with modkey
awful.key({modkey}, "Left", awful.tag.viewprev, {
    description = "view previous",
    group = "tag"
}), 

awful.key({modkey}, "Right", awful.tag.viewnext, {
    description = "view next",
    group = "tag"
}),

awful.key({altkey}, "Escape", awful.tag.history.restore, {
    description = "go back",
    group = "tag"
}), 

-- Tag browsing ALT+TAB (ALT+SHIFT+TAB)
awful.key({modkey}, "Tab", awful.tag.viewnext, {
    description = "view next",
    group = "tag"
}), 

awful.key({altkey, "Shift"}, "Tab", awful.tag.viewprev, {
    description = "view previous",
    group = "tag"
}), 

-- On the fly useless gaps change
awful.key({altkey, ctrlkey}, "j", function()
    lain.util.useless_gaps_resize(1)
end, {
    description = "increment useless gaps",
    group = "tag"
}),

awful.key({altkey, ctrlkey}, "k", function()
    lain.util.useless_gaps_resize(-1)
end, {
    description = "decrement useless gaps",
    group = "tag"
}), 

-- Dynamic tagging
awful.key({modkey, "Shift"}, "n", function()
    lain.util.add_tag()
end, {
    description = "add new tag",
    group = "tag"
}),

awful.key({modkey, ctrlkey}, "r", function()
    lain.util.rename_tag()
end, {
    description = "rename tag",
    group = "tag"
}),

awful.key({modkey, "Shift"}, "Left", function()
    lain.util.move_tag(-1)
end, {
    description = "move tag to the left",
    group = "tag"
}),

awful.key({modkey, "Shift"}, "Right", function()
    lain.util.move_tag(1)
end, {
    description = "move tag to the right",
    group = "tag"
}), 

awful.key({modkey, "Shift"}, "d", function()
    lain.util.delete_tag()
end, {
    description = "delete tag",
    group = "tag"
}), 

--------------------------------------------------------------------------------------
--                                CLIENT                                
--------------------------------------------------------------------------------------

-- Default client focus
awful.key({modkey}, "j", function()
    awful.client.focus.byidx(1)
end, {
    description = "Focus next by index",
    group = "client"
}), 

awful.key({modkey}, "k", function()
    awful.client.focus.byidx(-1)
end, {
    description = "Focus previous by index",
    group = "client"
}), 

-- By direction client focus
awful.key({altkey}, "j", function()
    awful.client.focus.global_bydirection("down")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus down",
    group = "client"
}),

awful.key({altkey}, "k", function()
    awful.client.focus.global_bydirection("up")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus up",
    group = "client"
}),

awful.key({altkey}, "h", function()
    awful.client.focus.global_bydirection("left")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus left",
    group = "client"
}),

awful.key({altkey}, "l", function()
    awful.client.focus.global_bydirection("right")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus right",
    group = "client"
}),

-- By direction client focus with arrows
awful.key({ctrlkey, modkey}, "Down", function()
    awful.client.focus.global_bydirection("down")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus down",
    group = "client"
}),

awful.key({ctrlkey, modkey}, "Up", function()
    awful.client.focus.global_bydirection("up")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus up",
    group = "client"
}),

awful.key({ctrlkey, modkey}, "Left", function()
    awful.client.focus.global_bydirection("left")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus left",
    group = "client"
}),

awful.key({ctrlkey, modkey}, "Right", function()
    awful.client.focus.global_bydirection("right")
    if client.focus then
        client.focus:raise()
    end
end, {
    description = "Focus right",
    group = "client"
}),

-- Layout manipulation
awful.key({modkey, "Shift"}, "j", function()
    awful.client.swap.byidx(1)
end, {
    description = "swap with next client by index",
    group = "client"
}),

awful.key({modkey, "Shift"}, "k", function()
    awful.client.swap.byidx(-1)
end, {
    description = "swap with previous client by index",
    group = "client"
}), 

awful.key({modkey}, "u", awful.client.urgent.jumpto, {
    description = "jump to urgent client",
    group = "client"
}),

awful.key({modkey, ctrlkey}, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
        client.focus = c
        c:raise()
    end
end, {
    description = "restore minimized",
    group = "client"
}), 

--------------------------------------------------------------------------------------
--                                SCREEN                                
--------------------------------------------------------------------------------------

awful.key({modkey}, ".", function()
    awful.screen.focus_relative(1)
end, {
    description = "focus the next screen",
    group = "screen"
}),

awful.key({modkey}, ",", function()
    awful.screen.focus_relative(-1)
end, {
    description = "focus the previous screen",
    group = "screen"
}), 

--------------------------------------------------------------------------------------
--                                LAYOUT                                
--------------------------------------------------------------------------------------

awful.key({modkey}, "l", function()
    awful.tag.incmwfact(0.05)
end, {
    description = "increase master width factor",
    group = "layout"
}), 

awful.key({modkey}, "h", function()
    awful.tag.incmwfact(-0.05)
end, {
    description = "decrease master width factor",
    group = "layout"
}), 

awful.key({modkey, "Shift"}, "Up", function()
    awful.tag.incnmaster(1, nil, true)
end, {
    description = "increase the number of master clients",
    group = "layout"
}), 

awful.key({modkey, "Shift"}, "Down", function()
    awful.tag.incnmaster(-1, nil, true)
end, {
    description = "decrease the number of master clients",
    group = "layout"
}), 

awful.key({modkey, ctrlkey}, "h", function()
    awful.tag.incncol(1, nil, true)
end, {
    description = "increase the number of columns",
    group = "layout"
}), 

awful.key({modkey, ctrlkey}, "l", function()
    awful.tag.incncol(-1, nil, true)
end, {
    description = "decrease the number of columns",
    group = "layout"
}), 

awful.key({modkey}, "Tab", function()
    awful.layout.inc(1)
end, {
    description = "select next",
    group = "layout"
}), 

awful.key({modkey, "Shift"}, "Tab", function()
    awful.layout.inc(-1)
end, {
    description = "select previous",
    group = "layout"
}), 

--------------------------------------------------------------------------------------
--                                SUPER                                
--------------------------------------------------------------------------------------

-- Dropdown application
awful.key({modkey}, "F12", function()
    awful.screen.focused().quake:toggle()
end, {
    description = "dropdown application",
    group = "super"
}),

--------------------------------------------------------------------------------------
--                                WIDGETS                                
--------------------------------------------------------------------------------------

-- Widgets popups
awful.key({altkey}, "c", function()
    lain.widget.cal.show(7)
end, {
    description = "show calendar",
    group = "widgets"
}),

awful.key({altkey}, "h", function()
    if beautiful.fs then
        beautiful.fs.show(7)
    end
end, {
    description = "show filesystem",
    group = "widgets"
}),

awful.key({altkey}, "w", function()
    if beautiful.weather then
        beautiful.weather.show(7)
    end
end, {
    description = "show weather",
    group = "widgets"
}),

--------------------------------------------------------------------------------------
--                                HOTKEYS                                
--------------------------------------------------------------------------------------

-- Run launcher
awful.key({modkey, "Shift"}, "Return", function()
    awful.util.spawn("dm-run")
end, {
    description = "Run launcher",
    group = "hotkeys"
}),

--------------------------------------------------------------------------------------
--                                ALSA VOLUME CONTROL                                
--------------------------------------------------------------------------------------

awful.key({modkey}, "F8", function()
    os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
    beautiful.volume.update()
end, {
    description = "increase volume",
    group = "alsa volume control"
}),

awful.key({modkey}, "F7", function()
    os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
    beautiful.volume.update()
end, {
    description = "decrease volume",
    group = "alsa volume control"
}),

awful.key({modkey}, "F6", function()
    os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
    beautiful.volume.update()
end, {
    description = "mute",
    group = "alsa volume control"
}))
