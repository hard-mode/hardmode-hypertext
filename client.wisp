(ns hardmode-ui-hypertext.client
  (:require [insert-css]
            [observ                     :as observer]
            [observ.watch               :as watch-value!]
            [virtual-dom.create-element :as create-element]
            [virtual-dom.diff           :as diff]
            [virtual-dom.h              :as $]
            [virtual-dom.patch          :as patch]))

(set! window.HARDMODE         (or window.HARDMODE         {}))
(set! window.HARDMODE.widgets (or window.HARDMODE.widgets {}))

(defn init-widgets! [& widgets]
  (console.log "Initializing a bunch of widgets:" widgets)
  (widgets.map (fn [widget]
    (console.log "Initializing widget:" widget)
    (let [script (require (:script widget))]
      (set! (aget window.HARDMODE.widgets (:id widget))
            (if script.init (script.init! widget)
                            (init-widget! widget)))))))

(defn init-widget! [widget]
  (let [script   (require (:script widget))
        style    (require (:style  widget))
        template script.template]

    (if style (insert-css style))

    (let [state (observer (:initial widget))]
      (set! (aget widget "state") state)
      (watch-value! state (get-updater widget)))

    widget))

(defn get-updater [widget]
  (fn update-widget! [state]
    (let [element   (:element widget)
          template  (:template (require (:script widget)))
          new-vtree (template widget state)]
      (if element
        (let [old-vtree (:vtree widget)
              patches   (diff old-vtree new-vtree)]
          (set! (aget widget "vtree")   new-vtree)
          (set! (aget widget "element") (patch element patches)))
        (let [element   (create-element! new-vtree)]
          (set! (aget widget "vtree")   new-vtree)
          (set! (aget widget "element") element)
          (document.body.appendChild    element))))))
