open Pp
open Util
open Constrarg
open Names
open String_syntax_plugin.String_syntax
open Constrexpr
open Glob_term
open Tacexpr

let __coq_plugin_name = "tacstringident"
let _ = Mltop.add_known_module "tacstringident"

let pr_ident_of_string _ _ _ _ = mt ()

let wit_ident_of_string : (constr_expr, glob_constr, intro_pattern) Genarg.genarg_type =
  Genarg.make0 "ident_of_string"

let intern ist (c : constr_expr) =
  let c = Constrintern.intern_constr (Global.env ()) c in
  (ist, c)

let subst subst c = Detyping.subst_glob_constr subst c

let ipattern_tag = Geninterp.val_tag (Genarg.topwit wit_intro_pattern)

let interp ist c = match (uninterp_string c) with
| None ->
  Ftactic.lift
    (Tacticals.New.tclZEROMSG (str "The term does not represent a string"))
| Some s ->
  if not (Id.is_valid s) then
    Ftactic.lift
      (Tacticals.New.tclZEROMSG (str "The string '" ++ str s ++ str "' is not a valid identifier"))
  else
    let open Misctypes in
    let r = (Loc.ghost, IntroNaming (IntroIdentifier (Id.of_string s))) in
    let r = Geninterp.Val.inject ipattern_tag r in
    Ftactic.return r

let () = Genintern.register_intern0 wit_ident_of_string intern
let () = Genintern.register_subst0 wit_ident_of_string subst
let () = Geninterp.register_interp0 wit_ident_of_string interp
let () = Geninterp.register_val0 wit_ident_of_string (Some ipattern_tag)
let () = Pptactic.declare_extra_genarg_pprule wit_ident_of_string
  pr_ident_of_string pr_ident_of_string pr_ident_of_string

open Pcoq
open Pcoq.Constr
open Pcoq.Tactic

let inj c = TacGeneric (Genarg.in_gen (Genarg.rawwit wit_ident_of_string) c)

GEXTEND Gram tactic_arg :
[ [ IDENT "ident_of_string"; c = constr -> inj c ] ];
END
