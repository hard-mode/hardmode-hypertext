(ns hardmode-ui-hypertext.template
  (:require
    [fs]
    [jade]
    [mori]
    [path]
    [wisp.runtime  :refer [=]]))

(defn path-absolute [p]
  (= (path.resolve p) (path.normalize p)))

(defn resolve [template]
  (if (path-absolute template) template
    (let [fullpath (path.resolve (path.join "." template))]
      (if (fs.exists-sync fullpath) fullpath
        (let [fullpath (path.resolve (path.join __dirname template))]
          (if (fs.exists-sync fullpath) fullpath
            (throw (Error. (str "Could not find template "
                                template)))))))))

(defn render [template context]
  (jade.renderFile (resolve template) context))

(defn extract [body]
  (mori.reduce
    (fn [templates member] (mori.conj templates (mori.get member "template")))
    (mori.vector) body))
