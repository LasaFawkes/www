(in-package :turtl-www)

(defparameter *root* (asdf:system-relative-pathname :turtl-www #P"")
  "Defines the root directory turtl-www is loading from (basically the ASDF path).")

(defparameter *pid-file* nil
  "File to write the current proc's PID to.")

