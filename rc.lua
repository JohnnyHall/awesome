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
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
-----------------------------------------------------

------------------ Error handling -------------------
local error = require("error")
-----------------------------------------------------

----------------- Variable definitions --------------

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({"unclutter -root"}) -- entries must be comma-separated
-----------------------------------------------------

----------------- Theme -----------------------------
local themes = {"powerarrow" -- 1
}

-- choose your theme here
local chosen_theme = themes[1]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)
-----------------------------------------------------

modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"

terminal = "alacritty"
browser = "firefox" --"qutebrowser"
editor = "vim"
emacs = "emacsclient -c -a 'emacs' "
mediaplayer = "mpv"
soundplayer = "ffplay -nodisp -autoexit "

-- awesome variables
awful.util.terminal = terminal


------------ Menu ------------
awful.util.tagnames = {" 1", " 2", " 3", " 4", " 5", " 6", " 7"} 
-- number of tags 7

-- awful.util.tagnames = {  " ", " ", " ", " ", " ", " ", " ", " ", " ", " " } 
-- number of tags 10

-- awful.util.tagnames = { " DEV ", " WWW ", " SYS ", " DOC ", " VBOX ", " CHAT ", " MUS ", " VID ", " GFX " } 
-- number of tags 9

number_tagnames = 7
------------------------------

awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {

-- o primeiro que aparece é o padrão
    awful.layout.suit.tile, 
    awful.layout.suit.floating 
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    -- lain.layout.cascade,
    -- lain.layout.cascade.tile,
    -- lain.layout.centerwork,
    -- lain.layout.centerwork.horizontal,
    -- lain.layout.termfair,
    -- lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(awful.button({}, 1, function(t)
    t:view_only()
end), awful.button({modkey}, 1, function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({modkey}, 3, function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end), awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
end), awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))

awful.util.tasklist_buttons = my_table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal("request::activate", "tasklist", {
            raise = true
        })
    end
end), awful.button({}, 3, function()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({
                theme = {
                    width = 250
                }
            })
        end
    end
end), awful.button({}, 4, function()
    awful.client.focus.byidx(1)
end), awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
end))

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

local myawesomemenu = {{"hotkeys", function()
    return false, hotkeys_popup.show_help
end}, 
{"manual", terminal .. " -e 'man awesome'"}, 
{"edit config", "emacsclient -c -a emacs ~/.config/awesome/rc.lua"},
{"arandr", "arandr"}, {"restart", awesome.restart}}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {{"Awesome", myawesomemenu, beautiful.awesome_icon} -- { "Atom", "atom" },
    -- other triads can be put here
    },
    after = {{"Terminal", terminal}, {"Log out", function()
        awesome.quit()
    end}, {"Sleep", "systemctl suspend"}, {"Restart", "systemctl reboot"}, {"Exit", "systemctl poweroff"} -- other triads can be put here
    }
})
-- menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it

local soundDir = "/opt/dtos-sounds/" -- The directory that has the sound files

local startupSound = soundDir .. "startup-01.mp3"
local shutdownSound = soundDir .. "shutdown-01.mp3"
local dmenuSound = soundDir .. "menu-01.mp3"

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)
end)

root.buttons(my_table.join(awful.button({}, 3, function()
    awful.util.mymainmenu:toggle()
end), awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev)))


------------ Awesome  ------------

local teclas2 = require("keybindings.teclas2")
local teclas = require("teclas")
----------------------------------


clientkeys = my_table.join(
    
awful.key({altkey, "Shift"}, "m", lain.util.magnify_client, {
    description = "magnify client",
    group = "client"
}), 

awful.key({modkey, "Shift"}, "c", function(c)
    c:kill()
end,{
    description = "close",
    group = "awesome"
}),

awful.key({modkey}, "t", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client"
}))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, number_tagnames do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == number_tagnames then
        descr_view = {
            description = "view tag #",
            group = "tag"
        }

        descr_toggle = {
            description = "toggle tag #",
            group = "tag"
        }

        descr_move = {
            description = "move focused client to tag #",
            group = "tag"
        }

        descr_toggle_focus = {
            description = "toggle focused client on tag #",
            group = "tag"
        }
    end

    -- View tag only.
    globalkeys = my_table.join(globalkeys,
    
    awful.key({modkey}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end, descr_view),
    
    -- Toggle tag display.
    awful.key({modkey, ctrlkey}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, descr_toggle),
    
    -- Move client to tag.
    awful.key({modkey, "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, descr_move), 
    
    -- Toggle tag on focused client.
    awful.key({modkey, ctrlkey, "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end, descr_toggle_focus))
end
-------------------------------------------------------------------------------


------------------- mouse -------------------
-- when dragging the mouse pointer in
-- any window it instantly focuses
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {
        raise = true
    })
end)


-- pressing the super key to move a window
-- in floating
clientbuttons = gears.table.join(awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {
        raise = true
    })
end), awful.button({modkey}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {
        raise = true
    })
    awful.mouse.client.move(c)
end), awful.button({modkey}, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", {
        raise = true
    })
    awful.mouse.client.resize(c)
end))
---------------------------------------------



-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = { -- All clients will match this rule.
{
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        size_hints_honor = false
    }
}}

--[[
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)
]]

--[[
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {
            raise = true
        })
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        c:emit_signal("request::activate", "titlebar", {
            raise = true
        })
        awful.mouse.client.resize(c)
    end))

    awful.titlebar(c, {
        size = 21
    }):setup{
        { 
            -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { 
            -- Middle
            { 
                -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { 
            -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
]]--

--------------------- border ---------------------
-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
--------------------------------------------------


------------------- set keys -------------------
root.keys(globalkeys)
------------------------------------------------


------------ autorun programs ------------
awful.spawn.with_shell("picom")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("nitrogen --restore &")
------------------------------------------
