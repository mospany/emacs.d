;;------------------------------------------------------------------------------
;;cedet
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/common")
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/contrib")
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/ede")
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/semantic")
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/srecode")
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/cogre")
(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/eieio")

;;(require 'cedet)
(load-file "~/.emacs.d/lib/cedet-1.1/common/cedet.el")
;(global-ede-mode 1)                      ; Enable the Project management system
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu
(setq auto-save-hook nil)

;;------------------------------------------------------------------------------
;;semantic
;;------------------------------------------------------------------------------
(setq semanticdb-search-system-databases t)
(setq semanticdb-default-save-directory "~/.emacs.semantic.cache/")

(global-semantic-highlight-edits-mode 1)
(global-semantic-show-parser-state-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; TAGS Menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Semantic DataBase�洢λ��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; semanticdb ����ʹ���������߲�����Tag������GNU Global������Tags�� ���԰�������Ĵ��������ã�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ʹ�� gnu global ��TAGS��
;;(require 'semantic/db-global)
;;(semanticdb-enable-gnu-global-databases 'c-mode)
;;(semanticdb-enable-gnu-global-databases 'c++-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; semantic����
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)

;; (setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))


;;������ת        
(global-set-key [f1] 'semantic-ia-fast-jump)  
(global-set-key [S-f1]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))

;;������ʵ�ּ���ת                    
(define-key c-mode-base-map [M-f1] 'semantic-analyze-proto-impl-toggle)                          



;;------------------------------------------------------------------------------
;;���벹ȫ
;;------------------------------------------------------------------------------

;;(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)
;;(add-to-list 'load-path "~/.emacs.d/lib/auto-complete-1.3.1")
;;(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
;;(require 'auto-complete-config)
;;(global-auto-complete-mode t)

(defun ac-complete-semantic-self-insert (arg) 
  (interactive "p") 
  (self-insert-command arg) 
  (ac-complete-semantic))

(defun cc-mode-ac-key-bindings () 
  (local-set-key "." 'ac-complete-semantic-self-insert) 
  (local-set-key ">" 'ac-complete-semantic-self-insert)
  (local-set-key ":" 'ac-complete-semantic-self-insert))

(add-hook 'c-mode-common-hook 'cc-mode-ac-key-bindings)
;;(define-key c-mode-base-map (kbd "M-n") 'ac-complete-semantic-self-insert)
(global-set-key (kbd "M-n") 'ac-complete-semantic-self-insert)


;;------------------------------------------------------------------------------
;;EDE����
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;;���ӻ���ǩ
;;------------------------------------------------------------------------------
;;(add-to-list 'load-path "~/.emacs.d/lib/cedet-1.1/eieio")
;;(require 'eieio nil 'noerror)
;;(enable-visual-studio-bookmarks)


;;------------------------------------------------------------------------------
;;h/cpp�л�
;;------------------------------------------------------------------------------
;;------------------------------------------------------------------------------
;;ͷ�ļ�/ʵ���ļ�֮����л���dts-switch-between-header-and-source
;;------------------------------------------------------------------------------

(defun dts-switch-between-header-and-source ()
  "Switch between a c/c++ header (.h) and its corresponding source (.c/.cpp)."
  (interactive)
  (setq bse (file-name-sans-extension buffer-file-name))
  (setq ext (downcase (file-name-extension buffer-file-name)))
  (cond
   ((or (equal ext "h") (equal ext "hpp"))
	;; first, look for bse.c 
	(setq nfn (concat bse ".c"))
	(if (file-exists-p nfn)
		(find-file nfn)
	  (progn
		(setq nfn (concat bse ".cpp"))
		(find-file nfn)
		)
	  )
	)
   ;; second condition - the extension is "cpp"
   ((equal ext "cpp")
	(setq nfn (concat bse ".h"))
	(if (file-exists-p nfn)
		(find-file nfn)
	  (progn
		(setq nfn (concat bse ".hpp"))
		(find-file nfn)
		)
	  )
	)
   
   ( (equal ext "c")
	 (setq nfn (concat bse ".h"))
	 (find-file nfn)
	 )
   
   ( (equal ext "hxx")
	 (setq nfn (concat bse ".cxx"))
	 (find-file nfn)
	 )
   
   ( (equal ext "cxx")
	 (setq nfn (concat bse ".hxx"))
	 (find-file nfn)
	 )
   
   ( (equal ext "hx")
	 (setq nfn (concat bse ".cx"))
	 (find-file nfn)
	 )
   
   ( (equal ext "cx")
	 (setq nfn (concat bse ".hx"))
	 (find-file nfn)
	 )
   
   );;endof:cond
  )

(require 'eassist nil 'noerror)
(define-key c-mode-base-map [f12] 'eassist-switch-h-cpp)											;;F12 ֻ�򿪴��ڵ��ļ�
(define-key c-mode-base-map [C-f12] 'dts-switch-between-header-and-source)    ;;C-F12 ǿ���л�ͷ�ļ���ʵ�֣������ڵ�ʱ��ᴴ����

;;--������չ
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))


;;------------------------------------------------------------------------------
;;�����۵�(�ն�ģʽ��,���۵����뿪ʼ��������+/-��)
;;------------------------------------------------------------------------------
										;(require 'semantic-tag-folding nil 'noerror)
										;(global-semantic-tag-folding-mode 1)

										;(define-key semantic-tag-folding-mode-map (kbd "C--") 'semantic-tag-folding-fold-block)
										;(define-key semantic-tag-folding-mode-map (kbd "C-=") 'semantic-tag-folding-show-block)

										;(define-key semantic-tag-folding-mode-map (kbd "C-c -") 'semantic-tag-folding-fold-all)
										;(define-key semantic-tag-folding-mode-map (kbd "C-c =") 'semantic-tag-folding-show-all)

;;------------------------------------------------------------------------------
;;�����۵�-���أ�gdb���Ե�ʱ����Ҫ�رմ����۵���
;;------------------------------------------------------------------------------
										;(global-set-key (kbd "C-?") 'global-semantic-tag-folding-mode)


;;=====================================================================================

(provide 'cedet1.1-settings)
