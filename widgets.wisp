(ns hardmode-ui-hypertext.widgets
  (:require
    [hardmode-ui-hypertext.routing
      :refer [route add-route]]
    [jade]
    [path]
    [send-data.html
      :as send-html]))

(defn page [options & body]
  (fn [context]
    (add-route context (route
      options.pattern
      options.template
      (fn [request response]
        (send-html request response
          { "body" (jade.renderFile
            (path.join __dirname "assets" "index.jade")
            {} ) }))))))

(defn input [] (fn []))

(defn list-view [] (fn []))
