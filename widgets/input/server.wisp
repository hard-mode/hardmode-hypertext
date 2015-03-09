(ns hardmode-ui-hypertext.widgets.input.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]))

(defn input [id & options]
  (widget __dirname id options))

(set! module.exports input)
