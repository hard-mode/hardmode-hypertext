(ns hardmode-ui-hypertext.client
  (:require [insert-css]
            [virtual-dom.create-element :as create-element]))

(set! window.HARDMODE         (or window.HARDMODE         {}))
(set! window.HARDMODE.widgets (or window.HARDMODE.widgets {}))

(defn init-widgets! [& widgets]
  (console.log widgets)
  (widgets.map (fn [widget-opts]
    (console.log "Initializing" widget-opts)
    (let [script (require (:script widget-opts))]
      (console.log script)
      (set! (aget window.HARDMODE.widgets (:id widget-opts))
            (if script.init (script.init! widget-opts)
                            (init-widget! widget-opts)))))))

(defn init-widget! [widget-opts]
  (let [script   (require (:script widget-opts))
        style    (require (:style  widget-opts))
        template script.template]

    (if style (insert-css style))

    (if template
      (let [rendered (template widget-opts)
            element  (create-element rendered)]
        (document.body.appendChild element)
        (set! (aget widget-opts "element") element)))

    widget-opts))
