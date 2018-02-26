;;; Copyright (c) 2012, Lorenz Moesenlechner <moesenle@in.tum.de>
;;; All rights reserved.
;;; 
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;; 
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * Neither the name of the Intelligent Autonomous Systems Group/
;;;       Technische Universitaet Muenchen nor the names of its contributors 
;;;       may be used to endorse or promote products derived from this software 
;;;       without specific prior written permission.
;;; 
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.

(in-package :cram-environment-representation)

(cpl:define-task-variable *object-identifier-to-instance-mappings*
    (make-hash-table :test #'equal)
    "Mapping from object-identifiers as bound in the
OBJECT-DESIGNATOR-DATA class to instance names in the bullet world
database.")

(cram-projection:define-special-projection-variable
    *object-identifier-to-instance-mappings*
    (alexandria:copy-hash-table *object-identifier-to-instance-mappings*))

(defun get-object-instance-name (object-identifier)
  (or (gethash object-identifier *object-identifier-to-instance-mappings*)
      ;; as a fallback, return the object identifier. This is not
      ;; really clean but makes integration of projection perception a
      ;; little easier.
      object-identifier))

(defun get-robot-object ()
  (with-vars-bound (?robot-name)
      (lazy-car (prolog `(robot ?robot-name)))
    (unless (is-var ?robot-name)
      (object *current-bullet-world* ?robot-name))))

(defun get-designator-object-name (object-designator)
  (let ((object-designator (desig:newest-effective-designator object-designator)))
    (when object-designator
      (get-object-instance-name
       (desig:object-identifier (desig:reference object-designator))))))

(defun get-designator-object (object-designator)
  (let ((object-name (get-designator-object-name object-designator)))
    (when object-name
      (object *current-bullet-world* object-name))))

(defun validate-location (designator pose)
  (desig:validate-location-designator-solution designator pose))
