(local {: merge : notify} (require :helpers))

(fn nest [options ...]
  ; (notify "nest options:" options "children: " ...)
  (merge options [...]))

(fn layout [layout options ...]
  (nest (merge {: layout} options) ...))

(fn widget [widget options ...]
  (nest (merge {: widget} options) ...))


{: layout
 : widget
 : nest
}
