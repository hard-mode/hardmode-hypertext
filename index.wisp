(ns hardmode-ui-hypertext.server
  (:require
    [hardmode-core.src.core
      :refer [execute-body!]]
    [http]
    [mori
      :refer [is-map assoc vector]]))

(defn input [] (fn []))

(defn list-view [] (fn []))

(defn page [options & body]
  (fn [context]
    (console.log options context (is-map context) (mori.get context "routes"))))

(defn listener [request response])

(defn server [port & body]
  (fn [context]
    (let [server  (http.createServer listener)
          context (assoc context :server server
                                 :routes (vector))]
      (console.log "Listening on" port)
      (server.listen port)
      (apply execute-body! context body))))
