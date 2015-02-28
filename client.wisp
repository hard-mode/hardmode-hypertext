(ns hardmode-ui-hypertext.client
  (:require [wisp.sequence :refer [map]]))

(defn init-widgets [& widgets]
  (map (fn [w] (console.log w)) widgets))
