(ns hardmode.ui.hypertext
  (:require
    [path]
    [mori                         :refer [assoc]]
    [hardmode.ui.hypertext.server :refer [Server]]))

(defn start-server [port & body]
  (fn start-server! [context]
    (let [redis-data (:redis-data context)
          module-dir (path.dirname module.filename)
          assets-dir (path.join module-dir "assets")
          server     (Server. context { :port port })]
      (redis-data.publish "watch" (path.join assets-dir "**" "*"))
      (body.map (fn [member]
        (member (assoc context :http server)))))))
