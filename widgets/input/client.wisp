(ns hardmode-ui-hypertext.widgets.input.client
  (:require [virtual-dom.h :as $]))

(defn template [widget]
  ($ "input" { :type "text" :id widget.id }))
