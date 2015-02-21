(ns hardmode-ui-hypertext
  (:require
    [hardmode-ui-hypertext.server  :as server]
    [hardmode-ui-hypertext.routing :as routing]
    [hardmode-ui-hypertext.widgets :as widgets]))

(def route      routing.route)
(def add-routes routing.add-routes)

(def page       widgets.page)
(def list-view  widgets.list-view)
(def input      widgets.input)

(def server     server.server-ui)
