(ns hardmode-ui-hypertext.page
  (:require
    [browserify]
    [hardmode-ui-hypertext.routing  :refer [route add-routes]]
    [hardmode-ui-hypertext.template :as template]
    [hardmode-ui-hypertext.widget   :refer [add-widget]]
    [mori                           :refer [assoc each reduce get-in to-js]]
    [path]
    [send-data]
    [send-data.json                 :as send-json]
    [send-data.html                 :as send-html]
    [url]
    [util]))

(defn respond-widget [request response context widget-id]
  (send-json request response (to-js
    (get-in context (mori.vector "widgets" widget-id) {}))))

(defn respond-page [request response body]
  (template.render
    "index.blade"
    { "body" body
      "mori" mori }
    (fn [err html]
      (if err (throw err))
      (send-html request response html))))

(defn serve-page [context body]
  (fn [request response]
    (let [method    request.method
          parsed    (url.parse request.url true) ; parse query string too
          url-path  parsed.path
          url-query parsed.query
          widget-id (aget url-query "widget")]
      (if widget-id
        (respond-widget request response context widget-id)
        (respond-page   request response body)))))

(defn page [options & body] (fn [context]
  (let [br        (browserify)
        context   (assoc context :browserify br)
        context   (reduce add-widget context body)]

    (br.add (path.resolve (path.join
      (path.dirname (require.resolve "wisp")) "engine" "browser.js")))
    (br.require (require.resolve "./client.wisp") { :expose "client" })
    (br.transform (require "wispify"))
    (br.transform (require "./bladeify.js"))

    (add-routes context

      (route options.pattern (serve-page context body))

      (route
        (str options.pattern "style")
        (fn [request response]
          (send-data request response "body { background: #333; color: #fff }")))

      (route
        (str options.pattern "script")
        (fn [request response]
          (br.bundle (fn [error bundled]
            (if error (throw error))
            (send-data request response (bundled.toString "utf8"))))))))))
