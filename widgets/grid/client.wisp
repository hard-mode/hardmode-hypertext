(ns hardmode-ui-hypertext.widgets.grid.client
  (:require [client :refer [init-widget! init-widgets!]]))

(defn init! [widget]
  (let [w (init-widget! widget)]
    (apply init-widgets! (:body widget))
    w))
