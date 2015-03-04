(ns hardmode-ui-hypertext.widgets.list-view.client
  (:require [client        :refer [init-widget!]]
            [virtual-dom.h :as    $]))

(defn template [options]
  ($ "ol" { :id options.id }))
