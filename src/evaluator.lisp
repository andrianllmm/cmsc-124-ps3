;;;; evaluator.lisp -- Part 2. Write the eight functions below.
;;;;
;;;; The toy language is a Lisp-1. One namespace holds both variables and
;;;; functions, so a variable bound to a closure is callable in operator
;;;; position and (f 1) works with no FUNCALL. The CLISP hosting this file is a
;;;; Lisp-2, which is why the host needs FUNCALL and #' where the toy language
;;;; needs neither. ANALYSIS.md asks you about that difference.
;;;;
;;;; An environment is an association list: ((name . value) (name . value) ...).
;;;; The grader scores E1 to E4 separately, so finish them in order and keep
;;;; every group you get right.
;;;;
;;;; The grammar, in full:
;;;;
;;;;   expr := number
;;;;         | symbol
;;;;         | (+ expr expr) | (- expr expr) | (* expr expr)
;;;;         | (let ((name expr) ...) body)
;;;;         | (lambda (name ...) body)
;;;;         | (operator-expr argument-expr ...)


;;; +--- E1 -- numbers and symbols. ---------------+
;; lookup(item, alist)
;; param item  - elem we are searching for
;; param alist - list we are searching
(defun lookup (name env)

  ;; assoc(item, alist)
  ;; param item  - elem we are searching for
  ;; param alist - list we are searching
  (let ((pair (assoc name env)))
    ;; map name -> env_elem
    (if pair  ;; if (name, env_elem) exists
      (cdr pair)  ;; return env_elem
      (error "Variable ~S is not in env." name))))
;;; +--- E1 -- numbers and symbols. ---------------+


;;; E2 -- prefix arithmetic.

(defun eval-operands (exprs env)
  "Every expression in EXPRS, evaluated in the same ENV, as a list.

MAPCAR and a LAMBDA do this in one line. Watch the arity: EVAL-EXPR takes two
arguments and MAPCAR hands its function one."
  (declare (ignore exprs env))
  (error "eval-operands is not implemented"))

(defun apply-op (op values)
  "Apply the arithmetic operator OP to the two numbers in VALUES.

OP is the symbol +, -, or *. Signal an error for anything else."
  (declare (ignore op values))
  (error "apply-op is not implemented"))



;;; +--- E3 -- let. ---------------+
;; extend-env(params, args, env)
;; param params - list of variable names
;; param args   - list of evaluated values corresponding to params
;; param env    - current environment list
(defun extend-env (params args env)
  "ENV with PARAMS bound to ARGS in front of it.

MAPCAR takes two lists and #'CONS pairs them. Build a new list. Do not modify
ENV, because the caller keeps using it after the extension goes out of scope."
  (declare (ignore params args env))
  (error "extend-env is not implemented"))

(defun eval-let (expr env)
  "Evaluate (let ((name init) ...) body).

Every init is evaluated in ENV before any name is bound, so the bindings happen
in parallel and an init cannot see a name the same LET introduces."
  (declare (ignore expr env))
  (error "eval-let is not implemented"))
;;; +--- E3 -- let. ---------------+



;;; E4 -- lambda and application.

(defun make-closure (params body env)
  "A closure over ENV.

Return the list (:closure params body env). ENV is the environment the lambda
was written in, not the one it will later be called from. Saving the wrong one
is what makes the difference between 3 and 101 in the case the manual walks
through."
  (declare (ignore params body env))
  (error "make-closure is not implemented"))

(defun apply-closure (closure args)
  "Run CLOSURE on ARGS.

The parameters join the environment the closure captured. Signal an error when
CLOSURE is not a closure, and when the argument count does not match."
  (declare (ignore closure args))
  (error "apply-closure is not implemented"))

;;; The dispatcher.

(defun eval-expr (expr env)
  "The value of EXPR in ENV.

Order the branches with care. NIL is a symbol as well as the empty list, and a
number is not a cons, so the atom tests come before the list tests."
  (cond
    ((numberp expr) expr)
    ((symbolp expr) (lookup expr env))
    (t (error "Cannot evaluate: ~S" expr))))
