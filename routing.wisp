(ns hardmode-ui-hypertext.routing
  (:require
    [wisp.runtime
      :refer [=]]
    [wisp.sequence
      :refer [reduce]]
    [mori
      :refer [hash-map assoc vector is-vector conj]]
    [hardmode-core.src.core
      :refer [assert]]))

(defn route [pattern handler]
  (hash-map :pattern pattern
            :handler handler))

(defn add-route [context new-route]
  (let [routes (or (mori.get context "routes") (vector))]
    (assoc context :routes (conj routes new-route))))

(defn add-routes [context & routes]
  (reduce (fn [context route] (add-route context route))
    context routes))
