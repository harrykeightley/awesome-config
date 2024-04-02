(local awful (require "awful"))
(local {: btn} (require :keybinds))

(fn with-focus [callback]
  (fn [c]
    (tset client :focus c)
    (c:raise)
    (callback c)))

(fn titlebar-btn [client modifiers btn-code action]
  (btn modifiers btn-code #((with-focus action) client)))

(fn create-titlebar [client]
  (let [btn (partial titlebar-btn client)
        buttons [(btn [] 1 awful.mouse.client.move) 
                 (btn [] 3 awful.mouse.client.resize)]
        bar (awful.titlebar 
              client 
              {:size 40
               :position :left
               : buttons})]
    (bar:setup)))

(client.connect_signal "request::titlebars" create-titlebar)

{: create-titlebar}
