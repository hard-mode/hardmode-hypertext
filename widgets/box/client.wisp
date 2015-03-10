(ns hardmode-ui-hypertext.widgets.box.client
  (:require [client        :refer [init-widget! init-widgets!]]
            [virtual-dom.h :as     $]))

(defn init! [widget]
  (apply init-widgets! (:body widget))
  (init-widget! widget))

(defn template [widget state]
  (console.log "box W" widget.body)
  ($ "div.box" (.map (or (:body widget) []) (fn [member] (:vtree member)))))
