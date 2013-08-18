(in-package :tagit-www)

;; TODO: rmoveme when not testing
(add-hook :pre-route (lambda (req res)
                       (declare (ignore req res))
                       (load-views))
          :load-views)

(defun page-not-found (res)
  "Sends a 404 error."
  (send-response res
                 :status 404
                 :body (layout 'default (list :content "Page not found."
                                              :title "Page not found."))))

;; clear out all routes (start anew)
(clear-routes)

(defroute (:get "/") (req res)
  (let ((body (load-view :pages/index :data '(:body-class "home"))))
    (send-response res :headers '(:content-type "text/html") :body body)))

(defroute (:get "/about") (req res)
  (let ((body (load-view :pages/about)))
    (send-response res :headers '(:content-type "text/html") :body body)))

(defroute (:get "/invites/([0-9a-f-]+)/([0-9a-f-]+)") (req res args)
  (let ((body (load-view :pages/invites)))
    (send-response res :headers '(:content-type "text/html") :body body)))

(defroute (:get "/refresh-views") (req res)
  (load-views)
  (send-response res :body "Views refreshed!!"))

(defroute (:get "/favicon.ico") (req res)
  (send-response res :status 301 :headers '(:location "/favicon.png")))

(def-directory-route "/" (format nil "~awebroot" *root*))

(defroute (:get "/docs(/(.*))?") (req res args)
  (handler-case
    (let* ((view (intern (string-upcase (format nil "docs/~a" (or (cadr args) "index"))) :keyword))
           (content (load-view view)))
      (send-response res :headers '(:content-type "text/html") :body content))
    (view-not-found ()
      (page-not-found res))
    (error (e)
      (send-response res :status 500 :body (format nil "~a" e)))))

(defroute (:* ".+") (req res)
  (page-not-found res))


