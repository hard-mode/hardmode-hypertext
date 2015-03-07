(ns hardmode-ui-hypertext.widgets.list-view.client
  (:require [client                     :refer [init-widget!]]
            [observ                     :as    observer]
            [observ.watch               :as    observe]
            [virtual-dom.create-element :as    create-element]
            [virtual-dom.h              :as    $]))

(defn init! [widget]
  (set! (aget widget "value") (observer (:value widget)))
  (init-widget! widget)
  (observe widget.value (get-updater widget))
  widget)

(defn template [widget]
  (let [values      ((:value widget))
        list-items  (if values (values.map (fn [value]
                      ((require (:item-template widget)) value)) []))]
    ($ "ul" { :id widget.id } list-items)))

(defn get-updater [widget]
  (fn update! [value]
    (let [old-element (:element widget)
          new-element (create-element (template widget))]
      (set! (aget widget "element") new-element)
      (old-element.parentElement.replaceChild new-element old-element))))

    ;((:element widget))
    ;(if value (console.log "UPDATED" value))))

    ;(if template
      ;(let [rendered (template widget-opts)
            ;element  (create-element rendered)]
        ;(document.body.appendChild element)
        ;(set! (aget widget-opts "element") element)))
