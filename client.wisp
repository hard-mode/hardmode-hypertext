(ns hardmode-ui-hypertext.client
  (:require [wisp.sequence :refer [map]]))

(defn init-widget! [widget]
  (let [container (document.createElement "div")]
    (set! (aget container "id") (:id widget))
    (document.body.appendChild container)))

(defn init-widgets! [& widgets]
  (map init-widget! widgets))
