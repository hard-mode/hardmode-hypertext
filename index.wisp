(ns hardmode.ui.hypertext
  (:require [hardmode.ui.hypertext.server :refer [Server]]))

(defn start-server [port & body]
  (fn start-server! [context]
    (let [server (Server. context { :port port })]
      (body.map (fn [member] (member context))))))
