(ns hardmode-ui-hypertext.widgets.list-view.server
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]
    [mori                         :refer [assoc conj]]))

(defn list-view [id & options]
  (let [widget (widget __dirname id options)
        deps   (mori.get widget "require")
        item   (mori.get widget "item-template")]
    (if item (assoc widget :require (conj deps item)) widget)))

(set! module.exports list-view)
