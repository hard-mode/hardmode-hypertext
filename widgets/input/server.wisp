(ns hardmode-ui-hypertext.widgets.input.server
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]
    [mori                         :refer [assoc conj]]))

(defn input [id & options]
  (widget __dirname id options))

(set! module.exports input)
