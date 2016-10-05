Require Import String Plugin.

Goal True.
Proof.
let id := ident_of_string "foobar"%string in pose (id := tt).
Fail let id := ident_of_string "::"%string in pose (id := tt).
Abort.
