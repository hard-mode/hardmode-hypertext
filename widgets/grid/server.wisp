(ns hardmode-ui-hypertext.widgets.grid.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget-container]]))

(defn grid [options & body]
  (widget-container __dirname "" options body))

(set! module.exports grid)
