(ns hardmode-ui-hypertext.widgets.grid.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [assoc to-clj]]))

(defn grid [options & body]
  (assoc (widget __dirname "" options) :body (to-clj body)))

(set! module.exports grid)
