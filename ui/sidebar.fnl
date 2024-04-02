(local awful (require "awful"))
(local wibox (require "wibox"))
(local beautiful (require "beautiful"))
(local {: create-taglist} (require :ui.taglist))
(local {: layout : widget} (require :ui.nest))
(local {: notify} (require :helpers))

(local dpi beautiful.xresources.apply_dpi)
(local thickness (dpi 40))
(fn gaps [n] (* n beautiful.useless_gap))

(local bg (partial widget wibox.container.background))
(local margin (partial widget wibox.container.margin))
(local align-vertical (partial layout wibox.layout.align.vertical))
(local fixed-vertical (partial layout wibox.layout.fixed.vertical))


(fn sidebar-widget [screen]
  (margin {:margins (gaps 2)}
    (align-vertical {:forced_width thickness}
      (bg {:bg beautiful.bg_normal}
        (margin {:margins 5}
          (fixed-vertical {:spacing 5}
            (create-taglist screen))))
      nil
      (align-vertical {:spacing 10
                       :bottom 10})))

  )

(fn create-sidebar [screen]
  (let [sidebar (awful.popup {
                       : screen
                       :placement (fn [c] ((+ awful.placement.left awful.placement.maximize_vertically) c))
                       ; :ontop false
                       ; :visible true
                       ; :width thickness
                       ; :height "750"
                       ; :x  (+ screen.geometry.x (* 2 beautiful.useless_gap))
                       ; :y  (+ screen.geometry.y (* 2 beautiful.useless_gap))
                       ; :stretch true
                       :bg "#00000000"
                       ; :fg beautiful.fg_normal
                       :widget (sidebar-widget screen)
                       })
        ]
    (sidebar:struts {:left (+ thickness (* beautiful.useless_gap 2))})))

; (screen.connect_signal "request::desktop_decoration" create-sidebar)
(awful.screen.connect_for_each_screen create-sidebar)

{}
