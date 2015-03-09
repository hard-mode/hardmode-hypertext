(ns hardmode-ui-hypertext.widgets.panel.server
  (:require
    [hardmode-ui-hypertext.widget :refer [widget]]))

(defn panel [id & options]
  (widget __dirname id options))

(set! module.exports panel)
