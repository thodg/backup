(require :cl-github-v3)

(setf github:*username* "thodg")
(setf github:*password* "")

(defvar *repos* nil)

(defun github-backup (user name)
  (let ((dir (repo::str "~/backup/github.com/" user "/" name ".git/")))
    (format t "~&~S~%" (pathname dir))
    (if (probe-file (pathname dir))
        (print (repo::sh "cd " dir " && git fetch -t"))
        (print (repo::sh "mkdir -p ~/backup/github.com/" user " && "
                         "cd ~/backup/github.com/" user " && "
                         "git clone --mirror git@github.com:" user "/"
                         name ".git ")))
    (force-output)))

(defun backup-all-github-repos (&optional update)
  (when (or update (null *repos*))
    (setf *repos* (github:list-repositories)))
  (dolist (repo *repos*)
    (cl-ppcre:do-register-groups (org repo-name)
        ("([^/]+)/(.+)" (getf repo :full-name))
      (github-backup org repo-name))))

(backup-all-github-repos)
