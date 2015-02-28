(ns hardmode-ui-hypertext.widgets.page
  (:require
    [hardmode-ui-hypertext.routing  :refer [route add-route]]
    [hardmode-ui-hypertext.template :as template]
    [hardmode-ui-hypertext.widget   :refer [add-widget]]
    [mori                           :refer [assoc each reduce]]
    [send-data.html                 :as send-html]))

(defn page [options & body]
  (fn [context]
    (let [context   (reduce add-widget context body)
          templates (mori.get context "templates")
          br        (mori.get context "browserify")]
      (each templates (fn [t]
        (br.require (template.resolve t) { :expose t })))
      (add-route context (route options.pattern (fn [request response]
        (template.render
          "templates/index.blade"
          { "body" body
            "mori" mori }
          (fn [err html]
            (if err (throw err))
            (send-html request response html)))))))))
