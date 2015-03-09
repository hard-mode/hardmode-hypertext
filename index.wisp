(ns hardmode-ui-hypertext
  (:require
    [fs]
    [hardmode-ui-hypertext.server  :as server]
    [hardmode-ui-hypertext.routing :as routing]
    [hardmode-ui-hypertext.page    :as page]
    [hardmode-ui-hypertext.widget  :as widget]
    [mori                          :refer [partial]]
    [path]))

(def page       page.page)
(def route      routing.route)
(def add-routes routing.add-routes)
(def server     server.server)

; manually require and export everything in ./widgets
(let [rel       (partial path.join __dirname "widgets")
      is-dir?   (fn [dir] (.isDirectory (fs.statSync (rel dir))))
      dirs      (.filter (fs.readdirSync (rel "")) is-dir?)
      fullpath  (fn [wid] (path.resolve (rel wid "server.wisp")))
      widgets   {}
      exporter  (fn [wid] (let [widget-module (require (fullpath wid))
                                widget-name   widget-module.name]
                  (set! (aget widgets widget-name) widget-module)))]
  (dirs.map exporter)
  (set! (aget module.exports "widgets") widgets))
