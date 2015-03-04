(ns hardmode-ui-hypertext.widgets.input.client
  (:require [client :refer [init-widget!]]))

(defn template [context]
  ($ "input" { :type "text" :id context.id }))
