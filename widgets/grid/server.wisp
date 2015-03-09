(ns hardmode-ui-hypertext.widgets.grid.server
  (:require
    [hardmode-ui-hypertext.server :refer [widget]]
    [mori                         :refer [assoc dissoc into map reduce
                                          set to-clj vector]]))

(defn grid [options & body]
  (let [widget (widget __dirname "" options)
        body   (to-clj body)
        deps   (reduce (fn [acc wid] (into acc (mori.get wid "requires"))) (set) body)]
    (assoc widget
      :body     (into (vector) (map (fn [member] (dissoc member "requires")) body))
      :requires (into (or (mori.get widget "requires") (vector)) deps))))

(set! module.exports grid)
