(ns hardmode-ui-hypertext.widgets.input
  (:require
    [hardmode-ui-hypertext.widgets :refer [widget]]))

(defn list-view [id options]
  (widget "templates/list.jade"  id options))
