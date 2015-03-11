(ns hardmode-ui-hypertext.widgets.panel.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [hash-map]]))

(defn panel [id & options]
  (widget __dirname id (apply hash-map options)))

(set! module.exports panel)
