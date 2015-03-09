(ns hardmode-ui-hypertext.client
  (:require [event-sinks]
            [html-delegator]
            [insert-css]
            [observ                     :as observer]
            [observ.watch               :as watch-value!]
            [virtual-dom.create-element :as create-element]
            [virtual-dom.diff           :as diff]
            [virtual-dom.h              :as $]
            [virtual-dom.patch          :as patch]
            [wisp.runtime               :refer [and]]))

(set! window.HARDMODE         (or window.HARDMODE         {}))
(set! window.HARDMODE.widgets (or window.HARDMODE.widgets {}))

(defn init-widgets! [& widgets]
  (console.log "Initializing a bunch of widgets:" widgets)
  (widgets.map (fn [widget]
    (console.log "Initializing widget:" widget)
    (set! (aget window.HARDMODE.widgets (:id widget))
      (if (and (:script widget) (.-init! (require (:script widget))))
        (.init! (require (:script widget)) widget)
        (init-widget! widget))))))

(def init-application! init-widgets!)

(defn init-widget! [widget]
  (if (:style widget)
    (insert-css (:style widget)))

  (set! (aget widget "template")
    (if (:template widget)
      (require (:template widget))
      (if (and (:script widget) (:template (:script widget)))
        (:template (:script widget)))))

  (let [state (observer (:initial widget))]
    (set! (aget widget "state") state)
    (watch-value! state (get-updater widget)))

  (let [delegator (html-delegator)
        sinks     (event-sinks [])
        events    { :delegator delegator
                    :sinks     sinks }]
    (set! (aget widget "events") events))

  widget)

(defn get-updater [widget]
  (fn update-widget! [state]
    (let [template (:template widget)]
      (if template
        (let [element   (:element widget)
              new-vtree (template widget state)]
          (if element
            (let [old-vtree (:vtree widget)
                  patches   (diff old-vtree new-vtree)]
              (set! (aget widget "vtree")   new-vtree)
              (set! (aget widget "element") (patch element patches)))
            (let [element   (create-element! new-vtree)]
              (set! (aget widget "vtree")   new-vtree)
              (set! (aget widget "element") element)
              (document.body.appendChild    element))))))))
