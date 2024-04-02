(local fun (require "fun"))
(local gears (require "gears"))
(local awful (require "awful"))
(local naughty (require "naughty"))
(local beautiful (require "beautiful"))
(require :error-handling)
(require "awful.autofocus")
(local user (require :user-vars))
(local {: keybind : btn : number-keybind } (require :keybinds))
(local {: run-cmd : toggle-key : first} (require :helpers))


;; Layouts
(local layouts [awful.layout.suit.tile
                awful.layout.suit.floating
                ; awful.layout.suit.tile.left
                ; awful.layout.suit.tile.bottom
                ; awful.layout.suit.tile.top
                ;
                ; awful.layout.suit.fair             
                ; awful.layout.suit.fair.horizontal,
                ;
                ; awful.layout.suit.spiral,        
                ; awful.layout.suit.spiral.dwindle,
                ;
                ; awful.layout.suit.max,          
                ; awful.layout.suit.max.fullscreen,
                ; awful.layout.suit.magnifier,    
                ;
                ; awful.layout.suit.corner.nw    
                ; awful.layout.suit.corner.ne,
                ; awful.layout.suit.corner.sw,
                ; awful.layout.suit.corner.se,
])

(local default-layout (first layouts))
;;; Tag managment
;;
; Map to store managed tags on a screen by screen basis
(local tags {})

(fn get-screen [?screen]
  (or ?screen mouse.screen 1))

(local default-tag-names (->> (fun.range 1 6)
                              fun.totable))

(fn create-tag [name ?layout ?screen-index]
  (awful.tag.add name {:screen (get-screen ?screen-index) 
                       :layout (or ?layout default-layout)}))

(fn create-default-tags [screen-index]
  (let [create-screen-tag (fn [name] (create-tag name default-layout screen-index))
        screen-tags (->> default-tag-names
                         (fun.map create-screen-tag)
                         fun.totable)]
    (tset tags screen-index screen-tags)))

(var tag-index 1)

(fn get-tags [?screen]
  (. tags (get-screen ?screen)))

(fn get-tag [index ?screen]
  (. (get-tags ?screen) index))

(fn current-tag [?screen]
  (get-tag tag-index ?screen))

(fn get-tag-name [tag]
  (tostring tag))

(fn has-tag [index]
  (not= nil (get-tag index)))

(fn has-tag-index [index]
  (-> (get-tags) 
      (length)
      (>= index)))


(fn get-or-create-tag [index]
  (when (not (has-tag index))
    (let [tag (create-tag index)
          tag-list (get-tags)]
      (table.insert tag-list index tag)))
  (get-tag index))


(macros
  {:with-selected-tag (fn [name body1 ...]
                     `(let [,name (. mouse.screen :selected_tag)]
                        (when ,name
                          ,body1
                          ,...)))})


(fn view-only
  [tag]
  (: tag :view_only))

(fn view-current-tag
  []
  (view-only (current-tag)))

(fn select-tag [index]
  (set tag-index index)
  (view-current-tag))

(fn toggle-tag [index]
  (let [tag (get-tag index)]
    (awful.tag.viewtoggle tag)))

; Move client to tag 
(fn move-client [tag-index client]
  (let [tag (get-tag tag-index)]
    (when (and tag client)
      (client:move_to_tag tag))))

(fn focus-client-in-direction [direction]
  (awful.client.focus.bydirection direction))

(fn on-focus-client
  [client]
  (let [focus-color (. client :focus_color)]
    ; focus (e.g. from rules) is applied before arrange and the client might not yet have a color
    (when focus-color
      (tset client :border_color beautiful.border_focus))))

(fn un-focus-client [client]
  (tset client :border_color (or beautiful.border_normal beautiful.border_color_normal)))

(fn focus-client [c]
  (when client 
    (tset client :focus c)
    (on-focus-client c)))

(fn unminimize-tag
  [tag]
  (fun.each (fn [client]
              (tset client :minimized false))
            (tag:clients)))


(fn revert-to-default-config []
  (run-cmd "awesome -r -c /etc/xdg/awesome/rc.lua"))


(fn place-at-end [client]
  (when (not awesome.startup)
    (awful.client.setslave client)))

(fn prevent-offscreen [client]
  (when (and awesome.startup
             (not client.size_hints.user_position)
             (not client.size_hints.program_position))
    (awful.placement.no_offscreen client)))

(fn random-wallpaper []
  (run-cmd "nitrogen --set-zoom-fill --random ~/Pictures/papes/"))

;;; Keybindings
(local global-keys
       (gears.table.join
         (keybind [:mod :shift      ] "q"         awesome.quit)
         (keybind [:mod :shift      ] "r"         awesome.restart)
         (keybind [:mod :shift      ] "w"         random-wallpaper)
         (keybind [:mod :shift :ctrl] "r"         revert-to-default-config)
         (keybind [:mod             ] "h"         #(focus-client-in-direction "left"))
         (keybind [:mod             ] "l"         #(focus-client-in-direction "right"))
         (keybind [:mod             ] "k"         #(focus-client-in-direction "up"))
         (keybind [:mod             ] "j"         #(focus-client-in-direction "down"))
         (keybind [:mod             ] "t"         #(awful.layout.inc layouts  1))
         (keybind [:mod             ] "Tab"       #(awful.tag.history.restore))
         (keybind [:mod             ] "space"     #(run-cmd "rofi -show drun"))
         (keybind [:mod             ] "Return"    #(awful.spawn user.terminal))
         (keybind [:mod :shift      ] "BackSpace" #(unminimize-tag (current-tag)))

         (number-keybind [:mod] select-tag)
         (number-keybind [:mod :ctrl] toggle-tag)
         ))

(local client-keys
       (gears.table.join
         (number-keybind [:mod :shift] move-client)

         (keybind [:mod             ] "q"      (fn [c] (c:kill)))
         (keybind [:mod :shift      ] "f"      (partial toggle-key :focusable))
         (keybind [:mod :shift      ] "o"      (partial toggle-key :floating))
         (keybind [:mod :shift      ] "s"      (partial toggle-key :sticky))
         (keybind [:mod :shift      ] "x"      (partial toggle-key :maximized_horizontal))
         (keybind [:mod :shift      ] "y"      (partial toggle-key :maximized_vertical))
         (keybind [:mod :shift      ] "m"      (partial toggle-key :maximized))
         (keybind [:mod :shift      ] "n"      (partial toggle-key :minimized))))

(local client-buttons
       (gears.table.join
         (btn [           ] 1 #($1:raise))
         (btn [:mod       ] 1 awful.mouse.client.move)
         (btn [:mod       ] 3 awful.mouse.client.resize)
         ))

(local rules [
              {:rule {}
               :properties {:focus awful.client.focus.filter
                            :keys client-keys
                            :buttons client-buttons
                            :border_width beautiful.border_width
                            :border_color beautiful.border_normal
                            :raise true
                            :screen awful.screen.preferred
                            :placement (+ awful.placement.no_overlap awful.placement.no_offscreen)}}

              ;; window titlebars
              {:rule_any {:type [:normal :dialog]}
               :properties {:titlebars_enabled true}}
              ])

(fn set-rules [rules]
  (tset awful.rules :rules rules))

(local client-event-handlers
  {"mouse::enter" (fn [c]
                    (when (awful.client.focus.filter c)
                      (focus-client c)))
   "focus"        on-focus-client
   "unfocus"      un-focus-client
   "manage"       (fn [c]
                    (place-at-end c)
                    (prevent-offscreen c))
   })

; Theming
(fn theme-path [name] 
  (string.format "%s/.config/awesome/themes/%s/theme.lua" (os.getenv "HOME") name))

(fn load-theme [name]
  (->> (theme-path name) 
       beautiful.init))

; (load-theme "dremora")
(load-theme "hydrangea")

; UI
(require :ui.titlebar)
(require :ui.sidebar)

; Force our layouts
(tset awful.layout :layouts layouts)

; Wire everything up
(fun.each client.connect_signal client-event-handlers)
(awful.screen.connect_for_each_screen create-default-tags)

; Setup global keybindings and rules
(root.keys global-keys)
(set-rules rules)

; View the fruits of our labour
(gears.wallpaper.set user.background-color)
(view-current-tag)

;; Post config commands to be run
(fun.each run-cmd user.post-config-cmds)

{}
