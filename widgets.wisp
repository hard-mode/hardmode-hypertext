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

(defn render-widgets [context widgets]
  (reduce
    (fn [rendered widget]
      (assoc rendered (mori.get widget "id")
        (render-template (mori.get widget "template")
                         (mori.get widget "options"))))
    (hash-map) widgets))

(defn extract-templates [widgets]
  (reduce
    (fn [templates widget]
      (mori.conj templates (mori.get widget "template")))
    (mori.set) widgets))

(defn page [options & body]
  (fn [context]
    (add-route context (route options.pattern (fn [request response]
      (send-html request response (render-template "templates/index.jade")))))))

(defn widget [template id options]
  (hash-map
    :id       id
    :template template
    :options  options))

(defn input [id options]
  (widget "templates/input.jade" id options))

(defn list-view [id options]
  (widget "templates/list.jade"  id options))
