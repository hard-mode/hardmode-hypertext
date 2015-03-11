(ns hardmode-ui-hypertext.widgets.button.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [hash-map to-clj]]))

(defn button [id & options]
  (widget __dirname id (to-clj options)))

(set! module.exports button)

