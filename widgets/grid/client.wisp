(ns hardmode-ui-hypertext.widgets.grid.client
  (:require [client :refer [init-widget! init-widgets!]]))

(defn init! [widget]
  (init-widget! widget)
  (apply init-widgets! (:body widget)))
