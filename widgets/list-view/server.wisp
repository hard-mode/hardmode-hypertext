(ns hardmode-ui-hypertext.widgets.list-view.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [assoc conj]]))

(defn list-view [id & options]
  (let [w    (widget __dirname id options)
        deps (mori.get w "requires")]
    (assoc w :requires (conj deps (mori.get w "item-template")))))

(set! module.exports list-view)
