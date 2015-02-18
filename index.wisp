(ns hardmode-ui-hypertext.server
  (:require
    [wisp.runtime    :refer [=]]
    [mori            :refer [hash-map is-map assoc 
                             vector is-vector conj]]
    [hardmode-core.src.core
                     :refer [execute-body!]]
    [http]
    [jade]
    [path]
    [send-data.html  :as send-html]
    [send-data.error :as send-error]))

(defn input [] (fn []))

(defn list-view [] (fn []))

(defn add-route [context new-route]
  (let [routes (mori.get context "routes")]

    ; assertions
    (assert routes (str "routes is missing from context; "
                        "(page) called outside (server)?"))
    (assert (is-vector routes) "routes is not a vector?!")

    ; return context with added route
    (assoc context :routes (conj routes new-route))))

(defn page [options & body]
  (fn [context]
    (add-route context (hash-map
      :pattern  options.pattern
      :template options.template
      :handler
      (fn [request response]
        (send-html request response
          { "body" (jade.renderFile
            (path.join __dirname "assets" "index.jade")
            {} ) }))))))

(defn get-request-handler [context]
  (fn request-handler [request response]
    (let [routes (mori.get context "routes")
          match  (fn [route] (= request.url (mori.get route "pattern")))
          route  (mori.first (mori.filter match routes))]
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
