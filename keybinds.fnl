(local fun (require "fun"))
(local gears (require "gears"))
(local awful (require "awful"))
(local {: modkey} (require :user-vars))

(local modifiers {:mod   modkey
                  :shift "Shift"
                  :ctrl  "Control"})

(fn map-mods
  [mods]
  (->> mods
       (fun.map (partial . modifiers))
       (fun.totable)))

(fn keybind
  [mods key-code on-press ?opts]
  (awful.key (map-mods mods) key-code on-press (or ?opts {})))

(fn num-keycode [num]
  (.. "#" (+ num 9)))

(fn number-keybind
  [mods fun ?opts]
  (let [key-from-num #(keybind mods (num-keycode $1) (partial fun $1) ?opts)
        keys (fcollect [i 1 9]
              (key-from-num i))]
        
    (gears.table.join (table.unpack keys))))

(fn btn
  [mods btn-code fun]
  (awful.button (map-mods mods) btn-code fun))

{: keybind
 : number-keybind
 : btn}
