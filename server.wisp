(ns hardmode-ui-hypertext.server
  (:require
    [hardmode-core.src.core         :refer [execute-body!]]
    [hardmode-ui-hypertext.routing  :refer [route add-routes]]
    [hardmode-ui-hypertext.template :as    template]
    [browserify]
    [http]
    [mori            :refer [hash-map assoc vector first filter]]
    [path]
    [send-data.error :as send-error]
    [send-data]
    [wisp.runtime    :refer [=]]
    [wisp.sequence   :refer [reduce]] ))

(defn get-request-handler [context]
  (fn request-handler [request response]
    (let [routes (mori.get context "routes")
          match  (fn [route] (= request.url (mori.get route "pattern")))
          route  (first (filter match routes))]
      (console.log "Requested" request.url)
      (if route
        ((mori.get route "handler") request response)
        (send-error request response { "body" (Error. "404") })))))

(defn server-core [port & body]
  (fn [context]
    (let [server  (http.createServer)
          context (assoc context :server server)]
      (console.log "Listening on" port)
      (server.listen port)
      (let [new-context (apply execute-body! context body)]
        (server.on "request" (get-request-handler new-context))
        new-context))))

(defn server-ui [port & body]
  (fn [context]
    (let [br            (browserify)
          context       (assoc context :browserify br)
          wispify       (require "wispify")
          jadeify       (require "jadeify")
          transformJade (require "./transform_jade.js")]

      (br.add (path.resolve (path.join
        (path.dirname (require.resolve "wisp")) "engine" "browser.js")))
      (br.require (require.resolve "reflux"))
      (br.require (require.resolve "./client.wisp") { :expose "client" })
      (br.transform wispify)
      (br.transform jadeify { :compiler transformJade.DynamicMixinsCompiler})
      (br.transform transformJade)

      ((apply server-core port body) (add-routes context

        (route "/style"  (fn [request response]
          (send-data request response "body { background: #333; color: #fff }")))

        (route "/script" (fn [request response]
          (br.bundle (fn [error bundled]
            (if error (throw error))
            (send-data request response (bundled.toString "utf8")))))))))))
