(ns hardmode-ui-hypertext.widget
  (:require
    [hardmode-ui-hypertext.template :as template]
    [mori         :refer [assoc conj hash-map merge partial to-clj vector]]
    [path]
    [wisp.runtime :refer [or =]]))

(defn widget [widget-dir id options]
  (let [widget-name (path.basename widget-dir)]
    (merge
      (hash-map
        :name     widget-name
        :dir      widget-dir
        :template (path.join widget-dir (str widget-name ".blade"))
        :script   (path.join widget-dir (str widget-name "_client.wisp"))
        :id       id)
      (apply hash-map options))))

(defn add-widget [context widget]
  (let [c  (partial mori.get context)
        w  (partial mori.get widget)
        br (c "browserify")]
    (br.require (w "template"))
    (br.require (w "script"))
    (assoc context :widgets
      (assoc (or (c "widgets") (hash-map)) (w "id") widget))))

(defn add-widgets [context & widgets]
  (reduce add-widget context widgets))
