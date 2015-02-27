(ns hardmode-ui-hypertext.widget
  (:require
    [mori :refer [hash-map to-clj]]))

(defn widget [template id options]
  (hash-map
    :id       id
    :template template
    :options  (to-clj options)))
