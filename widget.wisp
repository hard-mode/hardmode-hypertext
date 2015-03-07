(ns hardmode-ui-hypertext.widget
  (:require
    [fs]
    [hardmode-ui-hypertext.template :as template]
    [mori         :refer [assoc conj hash-map merge partial to-clj vector]]
    [path]
    [wisp.runtime :refer [or not nil? =]]))

(defn widget [w-dir id options]
  (let [options   (apply hash-map options)
        o         (partial mori.get options)

        w-name    (path.basename w-dir)
        w-rel     (fn [suffix]  (path.join w-dir (str w-name suffix)))

        if-exists (fn [filename] (if (fs.existsSync filename) filename nil))
        script    (or (o "script") (if-exists (w-rel "_client.wisp")))
        style     (or (o "style")  (if-exists (w-rel ".styl")))
        requires  [script style]
        requires  (apply vector (requires.filter (fn [v] (not (nil? v)))))
        defaults  (hash-map :widget   w-name
                            :id       id
                            :dir      w-dir
                            :script   script
                            :style    style
                            :requires requires)]
    (merge defaults options)))

(defn add-widget [context widget]
  (let [c  (partial mori.get context)
        w  (partial mori.get widget)
        br (c "browserify")]
    (mori.each (w "requires") (fn [file] (br.require file)))
    (assoc context :widgets
      (assoc (or (c "widgets") (hash-map)) (w "id") widget))))

(defn add-widgets [context & widgets]
  (reduce add-widget context widgets))
