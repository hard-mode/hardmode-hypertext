(ns hardmode-ui-hypertext.widgets.page
  (:require
    [hardmode-ui-hypertext.routing  :refer [route add-route]]
    [hardmode-ui-hypertext.template :as template]
    [mori                           :refer [assoc each]]
    [send-data.html                 :as send-html]))

(defn page [options & body]
  (fn [context]
    (let [context   (assoc context :templates (template.extract body))
          templates (mori.get context "templates")
          br        (mori.get context "browserify")]
      (each templates (fn [t]
        (br.require (template.resolve t) { :expose t })))
      (add-route context (route options.pattern (fn [request response]
        (send-html request response (template.render "templates/index.jade"
          { "body" body
            "mori" mori }))))))))
