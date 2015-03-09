(ns hardmode-ui-hypertext.widgets.button.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]))

(defn button [id & options]
  (widget __dirname id options))

(set! module.exports button)

