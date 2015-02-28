(ns hardmode-ui-hypertext.widget
  (:require
    [mori         :refer [assoc conj hash-map partial to-clj vector]]
    [wisp.runtime :refer [or]]))

(defn widget [template id options]
  (hash-map
    :id       id
    :template template
    :options  (to-clj options)))

(defn add-widget [context widget]
  (let [ctx       (partial mori.get context)
        wid       (partial mori.get widget)
        widgets   (or (ctx "widgets")   (hash-map))
        templates (or (ctx "templates") (vector))]
    (assoc context
      :widgets   (assoc widgets (wid "id") widget)
      :templates (conj templates (wid "template")))))
