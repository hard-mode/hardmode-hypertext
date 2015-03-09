(ns hardmode-ui-hypertext.widgets.list-view.client
  (:require [client                     :refer [init-widget!]]
            [virtual-dom.create-element :as     create-element]
            [virtual-dom.diff           :as     diff]
            [virtual-dom.h              :as     $]
            [virtual-dom.patch          :as     patch]))

(defn template [widget state]
  (let [values      (:value state)
        list-items  (if values (values.map (fn [value]
                      ((require (:item-template widget)) value)) []))]
    ($ "ul" { :id widget.id } list-items)))

;(defn get-updater [widget]
  ;(fn update! [value]
    ;(update-widget! value)))

    ;((:element widget))
    ;(if value (console.log "UPDATED" value))))

    ;(if template
      ;(let [rendered (template widget-opts)
            ;element  (create-element rendered)]
        ;(document.body.appendChild element)
        ;(set! (aget widget-opts "element") element)))
