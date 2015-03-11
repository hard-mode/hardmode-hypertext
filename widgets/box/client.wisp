(ns hardmode-ui-hypertext.widgets.box.client
  (:require [client        :refer [init-widget! init-widgets!]]
            [virtual-dom.h :as     $]
            [wisp.runtime  :refer [=]]))

(defn init! [widget]
  (apply init-widgets! (:body widget))
  (init-widget! widget))

(defn template [widget state]
  (let [classes  ["box" (or (:direction widget) "")]
        children (.map (or (:body widget) []) (fn [member] (:vtree member)))]
  ($ (str "div" "." (.join classes ".")) children)))
