(ns hardmode-ui-hypertext.widgets.box.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget-container]]
    [mori                         :refer [hash-map to-clj vector conj assoc]]))

(defn box [direction sizes & body]
  (widget-container __dirname ""
    (hash-map :direction direction
              :sizes     (apply vector sizes)) body))

(set! module.exports box)
