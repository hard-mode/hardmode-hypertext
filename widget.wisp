(ns hardmode-ui-hypertext.widget
  (:require
    [hardmode-ui-hypertext.widgets.input :as input]
    [hardmode-ui-hypertext.widgets.list  :as list-view]
    [hardmode-ui-hypertext.widgets.page  :as page]
    [mori :refer [hash-map to-clj]]))

(defn widget [template id options]
  (hash-map
    :id       id
    :template template
    :options  (to-clj options)))

(def input     input.input)
(def list-view list-view.list-view)
(def page      page.page)
