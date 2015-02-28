(ns hardmode-ui-hypertext.widgets.input
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]))

(defn list-view [id options]
  (widget "templates/list.blade"  id options))
