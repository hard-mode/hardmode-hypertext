(ns hardmode-ui-hypertext.client
  (:require [insert-css]))

(set! window.HARDMODE         (or window.HARDMODE         {}))
(set! window.HARDMODE.widgets (or window.HARDMODE.widgets {}))

(defn init-widgets! [& widgets]
  (widgets.map (fn [widget-opts]
    (let [script (if (:script widget-opts) (require (:script widget-opts)))]
      (set!
        (aget window.HARDMODE.widgets (:id widget-opts))
        (if script
          (script widget-opts)
          (init-widget! widget-opts
            (fn [element] (document.body.appendChild element)))))))))

(defn init-widget! [widget-opts callback]
  (let [container (document.createElement "div")
        template  (if (:template widget-opts) (require (:template widget-opts)))
        style     (if (:style    widget-opts) (require (:style    widget-opts)))]

    (if style (insert-css style))

    (if template
      (template widget-opts (fn [err html]
        (if err (throw err))
        (set! (aget container "id") (:id widget-opts))
        (set! (aget container "innerHTML") html)
        (callback container))))

    (set! (aget widget-opts "container") container)

    widget-opts))
