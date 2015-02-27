(ns hardmode-ui-hypertext
  (:require
    [hardmode-ui-hypertext.server        :as server]
    [hardmode-ui-hypertext.routing       :as routing]
    [hardmode-ui-hypertext.widgets.input :as input]
    [hardmode-ui-hypertext.widgets.list  :as list-view]
    [hardmode-ui-hypertext.widgets.page  :as page]))

(def route      routing.route)
(def add-routes routing.add-routes)

(def page       page.page)
(def list-view  list-view.list-view)
(def input      input.input)

(def server     server.server-ui)

