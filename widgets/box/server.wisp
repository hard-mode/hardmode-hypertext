(ns hardmode-ui-hypertext.widgets.box.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget-container]]))

(defn box [options & body]
  (widget-container __dirname "" options body))

(set! module.exports box)
