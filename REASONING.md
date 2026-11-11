# Reasoning for the Predictions Table

Write one entry under every heading below, then commit this file together with
`predictions.tsv`, before you run a case or open `tests/expected.tsv`.

Each entry names the rule that produces the four predicted fields for that
case. One to three sentences is enough. The grader checks structure only. It
does not judge quality, and it sets no word minimum.

After you run the cases, add a short correction under each case you predicted
wrongly. Say what you predicted, what CLISP printed, and which rule you
misread. Those entries belong in the correction commits.

## P01

`+` is a function, so both arguments are evaluated first. `(* 2 3)` is 6, then `(+ 1 6)` is 7. A number is an integer, so no length.

## P02

`'(+ 1 2)` is just `(quote (+ 1 2))`, so the head is `quote`, a special operator. It returns the list `(+ 1 2)` untouched, a cons with 3 elements.

## P03

`nil` evaluates to itself. It's the empty list, so kind is null and length is 0. It's an atom, so no operator.

## P04

`t` evaluates to itself. It's a symbol that isn't `nil`, so length is none. It's an atom, so no operator.

## P05

`symbolp` is a function, so `nil` is evaluated first and passed in. `nil` is a symbol, so the result is `t`, a symbol with length none.

## P06

`car` is a function and `'()` is the empty list. `car` of the empty list is `nil`, so null with length 0.

## P07

`cons` is a function. It puts 1 in front of `(2 3)`, giving `(1,2,3)`, a cons with 3 elements.

## P08

`if` is a special operator. `(null '())` is true since `()` is `nil`, so only the first branch is evaluated and get the symbol `empty`. Symbols have no length.

## P09

`and` stops at the first `nil` with result `nil` (null, length 0). CLISP also treats `and` as a special operator, and that is checked first, so we put special-operator.

## P10

`progn` is a special operator that returns its last form. `defvar` makes `*ps3-rate*` special, so the `let` rebinding to 10 is seen inside `ps3-scale`. That's 3 \* 10 = 30.

## P11

`defun` is a macro. It defines the function and returns its name without calling it, so the value is the symbol `ps3-twice`.

## P12

`labels` is a special operator that defines a recursive local function. `down` conses n onto `down(n-1)` until 0, so `(down 3)` is `(3,2,1)`, a cons of length 3.

## P13

`mapcar` is a function. It applies `length` to each sublist, giving `(2,0,1)`.

## P14

`mapcar` is a function. The lambda squares each element, giving `(1,4,9)`.

## P15

`lambda` is a macro. Evaluating it only creates a function and doesn't call it, so the value is `#<function>` with kind function.

## P16

`let` is a special operator. We read `f` as looking up `factor` when it runs, and the nearest one then is 10, so `(funcall f 3)` is 30.

We predicted the value to be 30 from `f` looking up `factor = 10` as part of `funcall`'s scope. However, `f` looks up to `factor = 2` for `factor`'s value because it's part of `f`'s scope. The rule is that functions refer to the variable it can "see" in its scope, not the caller's scope. Therefore, the correct value is `6`.
