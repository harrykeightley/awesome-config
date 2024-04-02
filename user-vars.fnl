;;; User vars

(local terminal "kitty")
(local modkey "Mod4")
(local background-color "#330022")

; Commands that are run one by one after everything has loaded.
(local post-config-cmds [
  "picom"
  "xrdb ~/.Xresources"
  "nitrogen --set-zoom-fill --random ~/Pictures/papes/"
  ])

{: modkey
 : terminal
 : background-color
 : post-config-cmds}


