(provide 'exwm-my-config)

(require 'exwm-systemtray)
(exwm-systemtray-enable)
(start-process-shell-command "configure-lock-screen" nil "/usr/bin/xss-lock -n /usr/lib/xsecurelock/dim-screen.sh -l -- env XSECURELOCK_BLANK_TIMEOUT=5 XSECURELOCK_BLANK_DPMS_STATE=\"off\" xsecurelock && xset s on && xset s 180 30")
(start-process-shell-command "start-nm-applet" nil "/usr/bin/nm-applet")
(display-battery-mode)
(display-time)

;; Emacs server is not required to run EXWM but it has some interesting uses
;; (see next section).
(server-start)

;; Fix problems with Ido (if you use it).
(require 'exwm-config)
(exwm-config-ido)

(require 'exwm-randr)
(setq exwm-randr-workspace-output-plist '(0 "HDMI1"))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output eDP1 --mode 1920x1080 --pos 2560x0 --rotate normal --output HDMI1 --primary --mode 2560x1440 --pos 0x0 --rotate normal")
	    (setq exwm-randr-workspace-monitor-plist '(1 "HDMI1" 2 "HDMI1" 3 "HDMI1" 4 "HDMI1" 5 "HDMI1" 6 "eDP1" 7 "eDP1" 8 "eDP1" 9 "eDP1" 0 "eDP1" ))))
;	    ))
(exwm-randr-enable)

;; Set the initial number of workspaces (they can also be created later).
(setq exwm-workspace-number 4)

;; All buffers created in EXWM mode are named "*EXWM*". You may want to
;; change it in `exwm-update-class-hook' and `exwm-update-title-hook', which
;; are run when a new X window class name or title is available.  Here's
;; some advice on this topic:
;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
;; + For applications with multiple windows (e.g. GIMP), the class names of
;    all windows are probably the same.  Using window titles for them makes
;;   more sense.
;; In the following example, we use class names for all windows except for
;; Java applications and GIMP.
(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))
(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))

(setq exwm-input-global-keys
      `(
        ;; Bind "s-r" to exit char-mode and fullscreen mode.
        ([?\s-r] . exwm-reset)
        ([?\s-w] . exwm-workspace-switch)
        ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))
        ([?\s-&] . (lambda (command)
		     (interactive (list (read-shell-command "$ ")))
		     (start-process-shell-command command nil command)))
	([?\s-`] . (lambda ()
		     (interactive)
		     (start-process-shell-command "logout" nil "/usr/bin/pkill -KILL -u jczornik")))
	([?\s-b] . (lambda ()
		     (interactive)
		     (start-process-shell-command "chromium" nil "chromium")))
	([?\s-s] . (lambda ()
		     (interactive)
		     (start-process-shell-command "slack" nil "slack")))
	([s-<XF86AudioRaiseVolume>] . (lambda ()
		     (interactive)
		     (start-process-shell-command "lower volume" nil "pactl set-sink-volume @DEFAULT_SINK@ +10%")))
	([s-<XF86AudioLowerVolume>] . (lambda ()
		     (interactive)
		     (start-process-shell-command "lower volume" nil "pactl set-sink-volume @DEFAULT_SINK@ -10%")))
	([s-<XF86AudioMute>] . (lambda ()
		     (interactive)
		     (start-process-shell-command "mute volume" nil "pactl set-sink-volume @DEFAULT_SINK@ toggle")))
	([s-<XF86AudioMicMute>] . (lambda ()
		     (interactive)
		     (start-process-shell-command "mute volume" nil "pactl set-source-mute @DEFAULT_SOURCE@ toggle")))))
        ;; ([s-escape] . (lambda ()
	;; 	    (interactive)
	;; 	    (start-process "" nil "/usr/bin/xset s activate")))))
	;; ([?\s-`] . (lambda ()
	;; 	    (interactive)
	;; 	    (start-process "" nil "/usr/bin/xkill -KILL -u $(/usr/bin/whoami)")))))

;; To add a key binding only available in line-mode, simply define it in
;; `exwm-mode-map'.  The following example shortens 'C-c q' to 'C-q'.
(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

;; The following example demonstrates how to use simulation keys to mimic
;; the behavior of Emacs.  The value of `exwm-input-simulation-keys` is a
;; list of cons cells (SRC . DEST), where SRC is the key sequence you press
;; and DEST is what EXWM actually sends to application.  Note that both SRC
;; and DEST should be key sequences (vector or string).
(setq exwm-input-simulation-keys
      '(
        ;; movement
        ([?\C-b] . [left])
        ([?\M-b] . [C-left])
        ([?\C-f] . [right])
        ([?\M-f] . [C-right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ([?\C-a] . [home])
        ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete])
        ;; cut/paste.
        ([?\C-w] . [?\C-x])
        ([?\M-w] . [?\C-c])
        ([?\C-y] . [?\C-v])
        ;; search
        ([?\C-s] . [?\C-f])))

;; You can hide the minibuffer and echo area when they're not used, by
;; uncommenting the following line.
;(setq exwm-workspace-minibuffer-position 'bottom)

;; Do not forget to enable EXWM. It will start by itself when things are
;; ready.  You can put it _anywhere_ in your configuration.
(exwm-enable)
