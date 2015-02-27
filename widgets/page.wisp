(ns hardmode-ui-hypertext.widgets.page
  (:require
    [hardmode-ui-hypertext.routing  :refer [route add-route]]
    [hardmode-ui-hypertext.template :as template]
    [mori]
    [send-data.html                 :as send-html]))

(defn page [options & body]
  (fn [context]
    (add-route context (route options.pattern (fn [request response]
      (send-html request response (template.render "templates/index.jade"
        { "body" body
          "mori" mori })))))))
