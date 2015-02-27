(ns hardmode-ui-hypertext.widgets.input
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]))

(defn input [id options]
  (widget "templates/input.jade" id options))
