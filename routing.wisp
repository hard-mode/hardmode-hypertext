(ns hardmode-ui-hypertext.routing
  (:require
    [wisp.runtime
      :refer [=]]
    [mori
      :refer [hash-map assoc vector is-vector conj]]
    [hardmode-core.src.core
      :refer [assert]]))

(defn route [pattern handler]
  (hash-map :pattern pattern
            :handler handler))

(defn add-route [context new-route]
  (let [routes (mori.get context "routes")]

    ; assertions
    (assert routes (str "routes is missing from context; "
                        "(page) called outside (server)?"))
    (assert (is-vector routes) "routes is not a vector?!")

    ; return context with added route
    (assoc context :routes (conj routes new-route))))
