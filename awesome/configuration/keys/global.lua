local awful=require('awful')
local naughty = require("naughty")
local gears = require('gears')
local hotkeys_popup = require('awful.hotkeys_popup')
local apps = require('configuration.apps')
local screenshot = require('configuration.screenshot')
local menubar = require('menubar')
client = client or {}
awesome = awesome or {}
-- local screenshot = os.getenv("HOME") .. "/Pictures/scrot/$(date +%F_%T).png"
-- local scrot_full = "scrot ".. screenshot.." -e 'xclip -selecion c -t image/png < $f'"
local mods = {
  super = 'Mod4',
  shift = 'Shift',
  control = 'Control',
}

local globalkeys = gears.table.join(
  -- Keys to potentially remap
  awful.key(
    {mods.super}, 'Right', awful.tag.viewnext, {
      description = 'view next',
      group = 'tag',
    }
  ), awful.key(
    {mods.super}, 'Left', awful.tag.viewprev, {
      description = 'view previous',
      group = 'tag',
    }
  ),
  --
  --
  awful.key(
    {mods.super}, 's', hotkeys_popup.show_help, {
      description = 'show help',
      group = 'awesome',
    }
  ),awful.key(
    {mods.super}, 'Escape', awful.tag.history.restore, {
      description = 'go back',
      group = 'tag',
    }
  ), awful.key(
    {mods.super}, 'j', function() awful.client.focus.byidx(1) end, {
      description = 'focus next by index',
      group = 'client',
    }
  ), awful.key(
    {mods.super}, 'k', function() awful.client.focus.byidx(-1) end,
    {description = 'focus previous by index', group = 'client'}
  -- ), awful.key(
  --   {mods.super}, 'a', function() my_main_menu:show() end, {
  --     description = 'show main menu',
  --     group = 'awesome',
  --   }
  ), -- Layout manipulation
  awful.key(
    {mods.super, mods.shift}, 'j', function() awful.client.swap.byidx(1) end,
    {description = 'swap with next client by index', group = 'client'}
  ), awful.key(
    {mods.super, mods.shift}, 'k', function() awful.client.swap.byidx(-1) end,
    {description = 'swap with previous client by index', group = 'client'}
  ), awful.key(
    {mods.super, mods.control}, 'j', function() awful.screen.focus_relative(1) end,
    {description = 'focus the next screen', group = 'screen'}
  ), awful.key(
    {mods.super, mods.control}, 'k', function() awful.screen.focus_relative(-1) end,
    {description = 'focus the previous screen', group = 'screen'}
  ), awful.key(
    {mods.super}, 'u', awful.client.urgent.jumpto, {
      description = 'jump to urgent client',
      group = 'client',
    }
  ), awful.key(
    {mods.super}, 'Tab', function()
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    end, {description = 'go back', group = 'client'}
  ), -- Standard program
  awful.key(
    {mods.super}, 'Return', function() awful.spawn(apps.default.terminal) end, {
      description = 'open a terminal',
      group = 'launcher',
    }
    ),
    awful.key(
    {mods.super}, 't', function() awful.spawn(apps.default.web_browser) end, {
      description = 'open a web',
      group = 'launcher',
    }
  ),
  awful.key(
    { }, "Print", scrot_full , {
      description = 'take a screenshot',
      group = 'screen shot',
    }
    ),
  awful.key(
    {mods.super }, "Print", scrot_selection , {
      description = 'take a screenshot',
      group = 'screen shot',
    }
    ),
  awful.key(
    {mods.control }, "Print", scrot_window , {
      description = 'take a screenshot',
      group = 'screen shot',
    }
    ),
  awful.key(
    {mods.super, mods.control}, 'r', awesome.restart, {
      description = 'reload awesome',
      group = 'awesome',
    }
  ), awful.key(
    {mods.super, mods.shift}, 'q', awesome.quit, {
      description = 'quit awesome',
      group = 'awesome',
    }
  ), awful.key(
    {mods.super}, 'l', function() awful.tag.incmwfact(0.05) end,
    {description = 'increase master width factor', group = 'layout'}
  ), awful.key(
    {mods.super}, 'h', function() awful.tag.incmwfact(-0.05) end,
    {description = 'decrease master width factor', group = 'layout'}
  ), awful.key(
    {mods.super, mods.shift}, 'h', function() awful.tag.incnmaster(1, nil, true) end,
    {description = 'increase the number of master clients', group = 'layout'}
  ), awful.key(
    {mods.super, mods.shift}, 'l', function() awful.tag.incnmaster(-1, nil, true) end,
    {description = 'decrease the number of master clients', group = 'layout'}
  ), awful.key(
    {mods.super, mods.control}, 'h', function() awful.tag.incncol(1, nil, true) end,
    {description = 'increase the number of columns', group = 'layout'}
  ), awful.key(
    {mods.super, mods.control}, 'l', function() awful.tag.incncol(-1, nil, true) end,
    {description = 'decrease the number of columns', group = 'layout'}
  ), awful.key(
    {mods.super}, 'space', function() awful.layout.inc(1) end, {
      description = 'select next',
      group = 'layout',
    }
  ), awful.key(
    {mods.super, mods.shift}, 'space', function() awful.layout.inc(-1) end,
    {description = 'select previous', group = 'layout'}
  ), awful.key(
    {mods.super, mods.control}, 'n', function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then c:emit_signal(
        'request::activate', 'key.unminimize', {raise = true}
      ) end
    end, {description = 'restore minimized', group = 'client'}
  ), -- Prompt
  awful.key(
    {mods.super}, 'r', function() awful.screen.focused().mypromptbox:run() end,
    {description = 'run prompt', group = 'launcher'}
  ), awful.key(
    {mods.super}, 'x', function()
      awful.prompt.run {
        prompt = 'Run Lua code: ',
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. '/history_eval',
      }
    end, {description = 'lua execute prompt', group = 'awesome'}
  ), -- Menubar
  awful.key(
    {mods.super}, 'p', function() menubar.show() end, {
      description = 'show the menubar',
      group = 'launcher',
    }),
    awful.key({ mods.super, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}
    ),
  awful.key({}, "#122", function() awful.util.spawn("amixer set Master 2-") end),
  awful.key({}, "#123", function() awful.util.spawn("amixer set Master 2+") end)
)



clientkeys = gears.table.join(
  awful.key(
    {mods.super}, 'f', function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, {description = 'toggle fullscreen', group = 'client'}
  ), awful.key(
    {mods.super}, 'q', function(c) c:kill() end, {
      description = 'close',
      group = 'client',
    }
  ), awful.key(
    {mods.super, mods.control}, 'space', awful.client.floating.toggle, {
      description = 'toggle floating',
      group = 'client',
    }
  ), awful.key(
    {mods.super, mods.control}, 'Return', function(c) c:swap(awful.client.getmaster()) end,
    {description = 'move to master', group = 'client'}
  ), awful.key(
    {mods.super}, 'o', function(c) c:move_to_screen() end, {
      description = 'move to screen',
      group = 'client',
    }
  ), awful.key(
    {mods.super}, 't', function(c) c.ontop = not c.ontop end, {
      description = 'toggle keep on top',
      group = 'client',
    }
  ), awful.key(
    {mods.super}, 'n', function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end, {description = 'minimize', group = 'client'}
  ), awful.key(
    {mods.super}, 'm', function(c)
      c.maximized = not c.maximized
      c:raise()
    end, {description = '(un)maximize', group = 'client'}
  ), awful.key(
    {mods.super, mods.control}, 'm', function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end, {description = '(un)maximize vertically', group = 'client'}
  ), awful.key(
    {mods.super, mods.shift}, 'm', function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end, {description = '(un)maximize horizontally', group = 'client'}
  )
)

for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys, -- View tag only.
    awful.key(
      {mods.super}, '#' .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then tag:view_only() end
      end, {description = 'view tag #' .. i, group = 'tag'}
    ), -- Toggle tag display.
    awful.key(
      {mods.super, mods.control}, '#' .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then awful.tag.viewtoggle(tag) end
      end, {description = 'toggle tag #' .. i, group = 'tag'}
    ), -- Move client to tag.
    awful.key(
      {mods.super, mods.shift}, '#' .. i + 9, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:move_to_tag(tag) end
        end
      end, {description = 'move focused client to tag #' .. i, group = 'tag'}
    ), -- Toggle tag on focused client.
    awful.key(
      {mods.super, mods.control, mods.shift}, '#' .. i + 9, function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:toggle_tag(tag) end
        end
      end, {description = 'toggle focused client on tag #' .. i, group = 'tag'}
    )
  )
end

clientbuttons = gears.table.join(
  awful.button(
    {}, 1, function(c) c:emit_signal(
      'request::activate', 'mouse_click', {raise = true}
    ) end
  ), awful.button(
    {mods.super}, 1, function(c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.move(c)
    end
  ), awful.button(
    {mods.super}, 3, function(c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.resize(c)
    end
  )
)
return globalkeys

