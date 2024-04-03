# My Awesomewm Config
![Selection_006](https://github.com/harrykeightley/awesome-config/assets/24891460/be2878da-4eb9-410c-b896-83a426bd161a)

NOW WITH [FENNEL](https://fennel-lang.org/)!

I decided through looking at other peoples configs that lua is (in my opinion) a gross language for writing UIs, 
and people don't go far enough to tidy up their config...

Compare:
```fennel
(fn sidebar-widget [screen]
  (margin {:margins (gaps 2)}
    (align-vertical {:forced_width thickness}
      (bg {:bg beautiful.bg_normal}
        (margin {:margins 5}
          (fixed-vertical {:spacing 5}
            (create-taglist screen))))
      nil
      (align-vertical {:spacing 10
                       :bottom 10}
        time))))

(fn create-sidebar [screen]
  (let [sidebar (awful.popup
                      {: screen
                       :placement (fn [c] ((+ awful.placement.left awful.placement.maximize_vertically) c))
                       :ontop false
                       :bg "#00000000"
                       :widget (sidebar-widget screen)})]
    (sidebar:struts {:left (+ thickness (* beautiful.useless_gap 2))})))

; (screen.connect_signal "request::desktop_decoration" create-sidebar)
(awful.screen.connect_for_each_screen create-sidebar)
```
With
```lua
screen.connect_signal("request::desktop_decoration", function(s)
	awful
    .popup({
      placement = function(c)
        (awful.placement.left + awful.placement.maximize_vertically)(c)
      end,
      screen = s,
      bg = "#00000000",
      widget = {
        {
          {
            {
              {
                require "ui.bar.taglist"(s),
                layout = wibox.layout.fixed.vertical,
                spacing = 10,
              },
              widget = wibox.container.margin,
              margins = 5,
            },
            widget = wibox.container.background,
            bg = beautiful.bg_normal,
          },
          nil,
          {
            { widget = battery },
            { widget = time },
            layout = wibox.layout.fixed.vertical,
            spacing = 10,
            bottom = 10,
          },
          layout = wibox.layout.align.vertical,
          forced_width = 35,
        },
        widget = wibox.container.margin,
        margins = 20,
      },
    })
    :struts { left = 60 }
end)

```

The theme I'm using everywhere is rose-pine. 

## Dependencies
- `awesome` obviously
- `rofi` for opening programs
- `nitogen` for setting wallpapers
