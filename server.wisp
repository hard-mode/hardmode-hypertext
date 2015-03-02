(ns hardmode-ui-hypertext.server
  (:require
    [hardmode-core.util             :refer [execute-body!]]
    [hardmode-ui-hypertext.routing  :refer [route add-routes]]
    [hardmode-ui-hypertext.template :as    template]
    [browserify]
    [http]
    [mori            :refer [hash-map assoc vector first filter]]
    [path]
    [send-data.error :as send-error]
    [url]
    [wisp.runtime    :refer [=]]
    [wisp.sequence   :refer [reduce]] ))

(defn get-request-handler [context]
  (fn request-handler [request response]
    (let [routes   (mori.get context "routes")
          url-path (aget (url.parse request.url) "pathname")
          match    (fn [route] (= url-path (mori.get route "pattern")))
          route    (first (filter match routes))]
      (if route
        ((mori.get route "handler") request response)
        (send-error request response { "body" (Error. "404") })))))

(defn server [port & body]
  (fn [context]
    (let [server  (http.createServer)
          context (assoc context :server server)]
      (console.log "Listening on" port)
      (server.listen port)
      (let [new-context (apply execute-body! context body)]
        (server.on "request" (get-request-handler new-context))
        new-context))))
