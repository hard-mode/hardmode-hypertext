(ns hardmode-ui-hypertext.widgets.grid.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]))

(defn grid [options & body]
  (widget __dirname "" options))

(set! module.exports grid)

