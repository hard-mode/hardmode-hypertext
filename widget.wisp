(ns hardmode-ui-hypertext.widget
  (:require
    [fs]
    [hardmode-ui-hypertext.template :as template]
    [mori         :refer [assoc conj hash-map merge partial to-clj vector]]
    [path]
    [wisp.runtime :refer [or not nil? =]]))

(defn widget [w-dir id options]
  (let [w-name    (path.basename w-dir)
        w-rel     (fn [suffix]  (path.join w-dir (str w-name suffix)))
        if-exists (fn [filename] (if (fs.existsSync filename) filename nil))
        script    (or (if-exists (w-rel "_client.wisp")) (:script options))
        style     (or (if-exists (w-rel ".styl"))        (:style  options))
        defaults  (hash-map :widget w-name
                            :id     id
                            :dir    w-dir
                            :script script
                            :style  style)
        requires  [script style]
        requires  (apply vector (requires.filter (fn [v] (not (nil? v)))))]
    (merge
      (assoc defaults :require requires)
      (apply hash-map options))))

(defn add-widget [context widget]
  (let [c  (partial mori.get context)
        w  (partial mori.get widget)
        br (c "browserify")]
    (mori.each (w "require") (fn [file] (console.log file) (br.add file { :expose file })))
    (assoc context :widgets
      (assoc (or (c "widgets") (hash-map)) (w "id") widget))))

(defn add-widgets [context & widgets]
  (reduce add-widget context widgets))
