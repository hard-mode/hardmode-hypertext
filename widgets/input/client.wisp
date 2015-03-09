(ns hardmode-ui-hypertext.widgets.input.client
  (:require [virtual-dom.h :as $]))

(defn template [context]
  ($ "input" { :type "text" :id context.id }))
