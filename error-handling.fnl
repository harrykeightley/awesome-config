(local naughty (require "naughty"))

(fn critical-error [title msg]
  (naughty.notify 
    {:preset naughty.config.presests.critical
     :title title
     :text msg}))

; -- Check if awesome encountered an error during startup and fell back to
; -- another config (This code will only ever execute for the fallback config)
(when awesome.startup_errors
  (critical-error "Startup Errors" awesome.startup_errors))

; -- Handle runtime errors after startup
(var in-error false)
(awesome.connect_signal 
  "debug::error" 
  (fn [err]
    (when (not in-error)
      (set in-error true)
      (critical-error "Error!" (tostring err))))
      (set in-error false))

