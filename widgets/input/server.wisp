(ns hardmode-ui-hypertext.widgets.input.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [hash-map]]))

(defn input [id & options]
  (widget __dirname id (apply hash-map options)))

(set! module.exports input)
