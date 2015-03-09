(ns hardmode-ui-hypertext.widgets.button.client
  (:require [virtual-dom.h :as $]))

(defn template [context]
  ($ "button" { :id context.id } context.text))
