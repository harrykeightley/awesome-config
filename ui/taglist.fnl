(local beautiful (require "beautiful"))
(local gears (require "gears"))
(local awful (require "awful"))
(local wibox (require "wibox"))
(local {: btn} (require :keybinds))
(local {: layout 
        : widget} 
        (require :ui.nest))

(local bg (partial widget wibox.container.background))
(local margin (partial widget wibox.container.margin))
(local textbox (partial widget wibox.widget.textbox))
(local fixed-vertical (partial layout wibox.layout.fixed.vertical))

(local {: notify } (require :helpers))

(fn create-taglist [screen]
  ;; Individual tag template
  (let [widget_template (bg {:id :background_role}
                          (margin {:margins 6}
                            (textbox {:id :text_role
                                      :align :center
                                      :valign :center
                                      :fg beautiful.fg_normal
                                      })))
        ;; TODO not working??
        buttons (gears.table.join 
                  (btn [] 1 (fn [t]
                             (notify t)
                             (t:view_only))))
        taglist (awful.widget.taglist
                  {: screen
                   : widget_template
                   : buttons
                   :filter awful.widget.taglist.filter.all
                   :layout (fixed-vertical {:spacing 5})
                   })]
    (taglist:buttons buttons)

    taglist))

{ : create-taglist}
