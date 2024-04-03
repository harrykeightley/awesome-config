(local awful (require "awful"))
(local gears (require "gears"))
(local {: btn} (require :keybinds))
(local {: notify} (require :helpers))

(fn with-focus [callback]
  (fn [c]
    (tset client :focus c)
    (c:emit_signal "request::activate" "titlebar" {:raise true})
    ; (c:raise)
    (callback c)))

(fn titlebar-btn [client modifiers btn-code action]
  (btn modifiers btn-code #((with-focus action) client)))

(fn create-titlebar [client]
  ; (notify client)
  (let [btn (partial titlebar-btn client)
        buttons (gears.table.join
                  (btn [] 1 awful.mouse.client.move) 
                  (btn [] 3 awful.mouse.client.resize))
        bar (awful.titlebar 
              client 
              {:size 40
               :position :left
               : buttons})]
    (bar:buttons buttons)
    (bar:setup)

    ))

(client.connect_signal "request::titlebars" create-titlebar)

{: create-titlebar}
