(ns hardmode-ui-hypertext.client
  (:require [dom-delegator]
            ;[event-sinks]
            ;[html-delegator]
            [insert-css]
            [observ                     :as observer]
            [observ.watch               :as watch-value!]
            [virtual-dom.create-element :as create-element]
            [virtual-dom.diff           :as diff]
            [virtual-dom.h              :as $]
            [virtual-dom.patch          :as patch]
            [wisp.runtime               :refer [and]]))

(defn init-application! [& widgets]
  (set! window.HARDMODE         {})
  (set! window.HARDMODE.widgets {})
  (set! window.HARDMODE.events  (dom-delegator))
  (let [widgets (apply init-widgets! widgets)]
    (widgets.map (fn [widget]
      (if (:element widget) (document.body.appendChild (:element widget)))))))

(defn init-widgets! [& widgets]
  (console.log "Initializing a bunch of widgets:" widgets)
  (widgets.map (fn [widget]
    (console.log "Initializing widget:" widget)
    (set! (aget window.HARDMODE.widgets (:id widget))
      (if (and (:script widget) (.-init! (require (:script widget))))
        (.init! (require (:script widget)) widget)
        (init-widget! widget))))))

(defn init-widget! [widget]
  (if (:style widget)
    (insert-css (require (:style widget))))

  (set! (aget widget "template")
    (if (:template widget)
      (require (:template widget))
      (if (and (:script widget) (:template (require (:script widget))))
        (:template (require (:script widget))))))

  (let [state (observer (:initial widget))]
    (set! (aget widget "state") state)
    (watch-value! state (get-updater widget)))

  ;(let [delegator (html-delegator)
        ;sinks     (event-sinks [])
        ;events    { :delegator delegator
                    ;:sinks     sinks }]
    ;(set! (aget widget "events") events))

  widget)

(defn get-updater [widget]
  (fn update-widget! [state]
    (let [template (:template widget)]
      (if template
        (let [element   (:element widget)
              old-vtree (:vtree   widget)
              new-vtree (template widget state)]
          (set! (aget widget "vtree")   new-vtree)
          (set! (aget widget "element") (if element
            (patch element (diff old-vtree new-vtree))
            (create-element! new-vtree))))))))
