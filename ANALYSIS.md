# Environments and the Toy Evaluator

## Tracing the scope case

We picked the scope case to trace since it's the one where getting it wrong
actually shows:

```lisp
(let ((x 2))
  (let ((f (lambda (y) (+ x y))))
    (let ((x 100))
      (f 1))))
```

The outer `let` binds `x` to 2. Then the middle `let` has to evaluate the
`lambda`, and that lands in this branch of our `eval-expr`:

```lisp
((and (consp expr) (eq (first expr) 'lambda))
 (make-closure (second expr) (third expr) env))
```

So `f` becomes `(:closure (y) (+ x y) ((x . 2)))`. Next the inner `let` pushes
`(x . 100)` on the front, which means by the time we reach `(f 1)` the
environment looks like `((x . 100) (f . <closure>) (x . 2))`. Looking at that
list, it's easy to think `x` is 100 now.

But `(f 1)` goes to the application branch, which looks up `f`, gets the
closure, and calls `apply-closure`. The important line there is:

```lisp
(eval-expr body (extend-env params args env))
```

`env` here is the one stored inside the closure, not the current one. So the
body `(+ x y)` runs in `((y . 1) (x . 2))` and we get 3.

## Where the environment gets captured

It's the `lambda` branch, where we hand `env` to `make-closure`. At that
point `env` is just `((x . 2))`. The `(x . 100)` binding hasn't been made yet,
so there's no way for the closure to ever see it.

## What if we used the caller's environment

If `apply-closure` extended the caller's environment instead, `lookup` would
hit `(x . 100)` first and we'd get 101. That would make the toy language dynamically scoped, where a function uses whatever is bound when called instead of where it was written. The change is small but takes two edits: `apply-closure` would receive the caller's `env` as an extra parameter, and the application branch would pass the caller's `env` to it.

## Why CLISP needs funcall

Our language is a Lisp-1. There's only one alist, and the application branch
evaluates the head with `eval-expr` like anything else, so `f` is looked up
the same way `x` is. That's why `apply-twice` can just write `(g (g 1))`.

CLISP is a Lisp-2, so a symbol has a value and a separate function. `(g 1)`
only checks the function side, so a function sitting in the variable `g`
isn't found. `funcall` tells it to call the value instead, and `#'` does the
opposite, giving you a named function as a value. We ran into this ourselves
in `extend-env`: `mapcar` needs `#'cons`, because plain `cons` would be read
as a variable.