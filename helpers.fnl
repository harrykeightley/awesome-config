(local gears (require "gears"))
(local awful (require "awful"))
(local naughty (require "naughty"))
(local fun (require "fun"))

;; Recursively serialize some data
(fn serialize [v]
  (let [serialize-tbl 
         (fn [t] 
           (accumulate [res "TABLE"
                        k v (pairs t)]
             (.. res "\n\t" k " -> " (serialize v))))]
    (case (type v)
      "table" (serialize-tbl v)
      x (tostring v))))

(fn notify [...]
  (let [text (accumulate [res ""
                          _ v (ipairs [...])]
               (.. res " " (serialize v)))]
    (naughty.notify {: text})))

(fn ndebug
  [x]
  (notify (gears.debug.dump_return x)))


; (fn merge
;   [t kvs]
;   (fun.reduce #(doto $1 (tset $2 $3)) t kvs))

(fn merge [t kvs]
  (each [k v (pairs kvs)]
    (tset t k v))
  t)

(fn nest [options ...]
  ; (notify "nest options:" options "children: " ...)
  (merge options [...]))

(fn nth [index t]
  (. t index))

(local first (partial nth 1))

(fn find [filter t ?from-key]
  "Returns the first key in the table for which the filter 
  holds.

  The filter is a function to be called on the value associated 
  with the key."
  (let [key (next t ?from-key)]
    (if (not key)
        nil
        (if (filter (. t key))
            key
            (find filter t key)))))


(fn toggle-key [key tbl]
  "Toggle a given key in the supplied table"
  (let [value (. tbl key)]
    (tset tbl key (not value))))

(fn log-tbl [t ?msg]
  (when ?msg
    (print ?msg))
  (each [k v (pairs t)]
    (print "\t" k v)))

;; UI
(fn rounded-rect [radius]
  (fn [cr width height]
    (gears.shape.rounded_rect cr width height radius)))

(fn squircle [rate delta]
  (fn [cr width height]
    (gears.shape.squirecle cr width height rate delta)))

(fn hovered? [widget]
  (= widget (. mouse :current_wibox)))

(fn set-cursor [cursor widget]
  (tset widget :cursor cursor))

(local default-cursor "left_ptr")

; -- Add a hover cursor to a widget by changing the cursor on
; -- mouse::enter and mouse::leave
; -- You can find the names of the available cursors by opening any
; -- cursor theme and looking in the "cursors folder"
; -- For example: "hand1" is the cursor that appears when hovering over
; -- links
(fn add-cursor-hover [widget hover-cursor-type]
  (widget:connect_signal 
    "mouse::enter" 
    #(when (hovered? widget)
       (set-cursor hover-cursor-type widget)))
  (widget:connect_signal 
    "mouse::leave" 
    #(when (hovered? widget)
       (set-cursor default-cursor widget))))

;; Running commands
(fn run-cmd [cmd]
  (awful.spawn.with_shell cmd))

(fn run-cmd-and-write-file [cmd output-file callback]
  (awful.spawn.easy_async_with_shell (.. cmd " | tee " output-file) callback))

; (fn remote-watch [cmd interval output-file callback]
;   ())

; TODO Convert
; -- Useful for periodically checking the output of a command that
; -- requires internet access.
; -- Ensures that `command` will be run EXACTLY once during the desired
; -- `interval`, even if awesome restarts multiple times during this time.
; -- Saves output in `output_file` and checks its last modification
; -- time to determine whether to run the command again or not.
; -- Passes the output of `command` to `callback` function.
; function helpers.remote_watch(command, interval, output_file, callback)
;   local run_the_thing = function()
;     -- Pass output to callback AND write it to file
;     awful.spawn.easy_async_with_shell(command .. " | tee " .. output_file, function(out)
;       callback(out)
;     end)
;   end
;
;   local timer
;   timer = gears.timer {
;     timeout = interval,
;     call_now = true,
;     autostart = true,
;     single_shot = false,
;     callback = function()
;       awful.spawn.easy_async_with_shell("date -r " .. output_file .. " +%s", function(last_update, _, __, exitcode)
;         -- Probably the file does not exist yet (first time
;         -- running after reboot)
;         if exitcode == 1 then
;           run_the_thing()
;           return
;         end
;
;         local diff = os.time() - tonumber(last_update)
;         if diff >= interval then
;           run_the_thing()
;         else
;           -- Pass the date saved in the file since it is fresh enough
;           awful.spawn.easy_async_with_shell("cat " .. output_file, function(out)
;             callback(out)
;           end)
;
;           -- Schedule an update for when the remaining time to complete the interval passes
;           timer:stop()
;           gears.timer.start_new(interval - diff, function()
;             run_the_thing()
;             timer:again()
;           end)
;         end
;       end)
;     end,
;   }
; end
;
; return helpers

{: run-cmd
 : run-cmd-and-write-file
 : notify
 : log-tbl 
 : find 
 : merge
 : nth
 : first
 : toggle-key
}
