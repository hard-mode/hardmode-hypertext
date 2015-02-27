(ns hardmode-ui-hypertext
  (:require
    [hardmode-ui-hypertext.server  :as server]
    [hardmode-ui-hypertext.routing :as routing]
    [hardmode-ui-hypertext.widget  :as widget]))

(def route      routing.route)
(def add-routes routing.add-routes)

(def page       widget.page)
(def list-view  widget.list-view)
(def input      widget.input)

(def server     server.server-ui)

