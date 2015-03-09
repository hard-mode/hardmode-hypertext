(ns hardmode-ui-hypertext.page
  (:require
    [browserify]
    [hardmode-ui-hypertext.routing  :refer [route add-routes]]
    [hardmode-ui-hypertext.widget   :refer [add-widget!]]
    [hyperscript                    :as $]
    [mori                           :refer [assoc each reduce get-in to-js]]
    [path]
    [send-data]
    [send-data.json                 :as send-json]
    [send-data.html                 :as send-html]
    [url]
    [util]
    [wisp.runtime                   :refer [str]]))

; TODO fix source maps
; TODO use remapify or similar for shorter require paths

(defn page [options & body] (fn [context]
  (let [br        (browserify { :debug      false
                                :extensions [ ".wisp" ] })
        context   (assoc context :browserify br)
        context   (reduce add-widget context body)]

    (br.add (path.resolve (path.join
      (path.dirname (require.resolve "wisp/runtime"))
      "engine" "browser.js")))
    (br.require (path.join __dirname "client.wisp") { :expose "client" })
    (br.transform (require "wispify") { :global true })
    (br.transform (require "stylify") { :global true })

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

(defn serve-page [context body]
  (fn [request response]
    (let [method    request.method
          parsed    (url.parse request.url true) ; parse query string too
          url-path  parsed.path
          url-query parsed.query
          widget-id (aget url-query "widget")]
      (if widget-id
        (respond-component request response context widget-id)
        (respond-page      request response body)))))

(defn respond-page [request response body]
  (send-html request response (str
    "<!doctype html>"
    (.-outerHTML (page-template body)))))

(defn page-template [body]
  ($ "html" [
    ($ "head" [
      ($ "meta" { :charset "utf-8" })
      ($ "title" "Boepripasi")
      ($ "link" { :rel "stylesheet" :href "/style" })])
    ($ "body" [
      ($ "script" { :src "/script" })
      ($ "script" { :type "application/wisp" } (get-init-script body))])]))

(defn get-init-script [body]
  (str
    "\n(let [client (require \"client\")]"
    "\n  (client.init-widgets!"
    (reduce (fn [acc wid] (str acc "\n" wid)) "" body)
    "))"))

(defn respond-component [request response context widget-id]
  (send-json request response (to-js
    (get-in context (mori.vector "widgets" widget-id) {}))))
