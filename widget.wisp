(ns hardmode-ui-hypertext.widget
  (:require
    [hardmode-ui-hypertext.template :as template]
    [mori         :refer [assoc conj hash-map partial to-clj vector]]
    [path]
    [wisp.runtime :refer [or]]))

(defn widget [widget-dir id options]
  (let [widget-name (path.basename widget-dir)]
    (hash-map
      :name     widget-name
      :dir      widget-dir
      :template (path.join widget-dir (str widget-name ".blade"))
      :script   (path.join widget-dir (str widget-name "_client.wisp"))
      :id       id
      :options  (to-clj options))))

(defn add-widget [context widget]
  (let [ctx     (partial mori.get context)
        br      (ctx "browserify")
        widgets (or (ctx "widgets") (hash-map))

        w              (partial mori.get widget)
        w-template     (w "template")
        w-script       (w "script")
        w-script-alias (str "widgets/" (w "name") ".wisp")]

    (br.require (template.resolve w-template) { :expose w-template })
    (br.require w-script                      { :expose w-script-alias })

    (assoc context :widgets (assoc widgets (w "id") widget))))

(defn add-widgets [context & widgets]
  (reduce add-widget context widgets))
