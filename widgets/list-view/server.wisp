(ns hardmode-ui-hypertext.widgets.list-view.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [assoc conj hash-map]]))

(defn list-view [id & options]
  (let [w    (widget __dirname id (apply hash-map options))
        deps (mori.get w "requires")]
    (assoc w :requires (conj deps (mori.get w "item-template")))))

(set! module.exports list-view)
