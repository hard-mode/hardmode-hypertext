(ns hardmode-ui-hypertext.widgets.list-view.server
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]))

(defn list-view [id options]
  (widget __dirname id options))

(set! module.exports list-view)
