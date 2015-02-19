(ns hardmode-ui-hypertext.server
  (:require
    [hardmode-core.src.core
      :refer [execute-body!]]
    [http]
    [mori
      :refer [hash-map assoc vector first filter]]
    [send-data.error
      :as send-error]
    [wisp.runtime
      :refer [=]]))

(defn get-request-handler [context]
  (fn request-handler [request response]
    (let [routes (mori.get context "routes")
          match  (fn [route] (= request.url (mori.get route "pattern")))
          route  (first (filter match routes))]
      (console.log "Requested" request.url)
      (if route
        ((mori.get route "handler") request response)
        (send-error request response { "body" (Error. "404") })))))

(defn server [port & body]
  (fn [context]
    (let [server  (http.createServer)
          context (assoc context :server server
                                 :routes (vector))]
      (console.log "Listening on" port)
      (server.listen port)
      (let [new-context (apply execute-body! context body)]
        (server.on "request" (get-request-handler new-context))
        new-context))))
