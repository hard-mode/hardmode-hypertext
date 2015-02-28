(ns hardmode-ui-hypertext.client
  (:require [wisp.sequence :refer [map]]))

(defn init-widget! [widget]
  (let [container (document.createElement "div")
        template  (require (:template widget))]
    (set! (aget container "id") (:id widget))
    (console.log template)
    (document.body.appendChild container)))

(defn init-widgets! [& widgets]
  (map init-widget! widgets))
