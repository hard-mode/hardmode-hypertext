(ns hardmode-ui-hypertext.client)

(defn init-widgets! [& widgets]
  (console.log (widgets.map (fn [widget-opts]
    (let [script (if (:script widget-opts) (require (:script widget-opts)))]
      (if script
        (do (console.log script) (script widget-opts))
        (init-widget! widget-opts
          (fn [element] (document.body.appendChild element)))))))))

(defn init-widget! [widget-opts callback]
  (let [container (document.createElement "div")
        template  (require (:template widget-opts))]
    (template widget-opts (fn [err html]
      (if err (throw err))
      (set! (aget container "innerHTML") html)
      (callback container)))
    widget-opts))
