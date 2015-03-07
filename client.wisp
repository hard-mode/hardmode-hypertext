(ns hardmode-ui-hypertext.client
  (:require [insert-css]
            [virtual-dom.create-element :as create-element]))

(set! window.HARDMODE         (or window.HARDMODE         {}))
(set! window.HARDMODE.widgets (or window.HARDMODE.widgets {}))

(defn init-widgets! [& widgets]
  (console.log widgets)
  (widgets.map (fn [widget]
    (console.log "Initializing" widget)
    (let [script (require (:script widget))]
      (console.log script)
      (set! (aget window.HARDMODE.widgets (:id widget))
            (if script.init (script.init! widget)
                            (init-widget! widget)))))))

(defn init-widget! [widget]
  (let [script   (require (:script widget))
        style    (require (:style  widget))
        template script.template]

    (if style (insert-css style))

    (if template
      (let [rendered (template widget)
            element  (create-element rendered)]
        (document.body.appendChild element)
        (set! (aget widget "element") element)
        (console.log element)))

    widget))
