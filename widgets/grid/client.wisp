(ns hardmode-ui-hypertext.widgets.grid.client
  (:require [client        :refer [init-widget! init-widgets!]]
            [virtual-dom.h :as     $]))

(defn init! [widget]
  (let [w (init-widget! widget)]
    (apply init-widgets! (:body widget))
    w))

(defn template [widget state]
  ($ "h1" "GRID"))
