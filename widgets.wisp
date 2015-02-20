(ns hardmode-ui-hypertext.widgets
  (:require
    [hardmode-ui-hypertext.routing
      :refer [route add-route]]
    [hardmode-core.src.core
      :refer [execute-body! thru]]
    [wisp.runtime  :refer [=]]
    [wisp.sequence :refer [reduce]]
    [fs]
    [jade]
    [mori
      :refer [hash-map assoc to-js]]
    [path]
    [send-data.html
      :as send-html]))

(defn path-absolute [p]
  (= (path.resolve p) (path.normalize p)))

(defn find-template [template]
  (if (path-absolute template) template
    (let [fullpath (path.resolve (path.join "." template))]
      (if (fs.exists-sync fullpath) fullpath
        (let [fullpath (path.resolve (path.join __dirname template))]
          (if (fs.exists-sync fullpath) fullpath
            (throw (Error. (str "Could not find template "
                                template)))))))))

(defn render-template [template context]
  (jade.renderFile (find-template template) context))

(defn render-widgets [widgets]
  (reduce
    (fn [rendered widget]
      (assoc rendered (:id widget)
        (render-template (:template widget)
                         (:options  widget))))
    (hash-map) widgets))

(defn page [options & body]
  (fn [context]
    (add-route context (route
      options.pattern
      (fn [request response]
        (let [widgets (to-js (render-widgets body))]
          (console.log widgets)
          (send-html request response
            { "body"
              (render-template "templates/index.jade"
                { "body" (render-template (:template options)
                  { "widgets" widgets }) }) } ) ) ) ) ) ) ) 

(defn input [id options]
  { :id       id
    :template "templates/input.jade"
    :options  options } )

(defn list-view [id options]
  { :id       id
    :template "templates/list.jade"
    :options  options } )
