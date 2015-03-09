(ns hardmode-ui-hypertext.widgets.list-view.client
  (:require [virtual-dom.h :as $]))

(defn template [widget state]
  (let [values      (:value state)
        list-items  (if values (values.map (fn [value]
                      ((require (:item-template widget)) value)) []))]
    ($ "ul" { :id widget.id } list-items)))
