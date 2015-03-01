(ns hardmode-ui-hypertext.widgets.input.server
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]))

(defn input [id options]
  (widget __dirname id options))

(set! module.exports input)
