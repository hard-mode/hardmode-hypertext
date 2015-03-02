(ns hardmode-ui-hypertext.routing
  (:require
    [hardmode-core.util :refer [assert]]
    [wisp.runtime       :refer [=]]
    [wisp.sequence      :refer [reduce]]
    [mori               :refer [hash-map assoc vector is-vector conj]]))

(defn route [pattern handler]
  (hash-map :pattern pattern
            :handler handler))

(defn add-route [context new-route]
  (let [routes (or (mori.get context "routes") (vector))]
    (assoc context :routes (conj routes new-route))))

(defn add-routes [context & routes]
  (reduce add-route context routes))
