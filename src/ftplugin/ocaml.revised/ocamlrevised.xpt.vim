
if exists("b:__OCAML_REVISED_XPT_VIM__")
    finish
endif

let b:__OCAML_REVISED_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT letin hint=let\ ..\ =\ ..\ in
let `name^ `_^^ =
    `what^ `...^
and `subname^ `_^^ =
    `subwhat^`...^
in


XPT letrecin hint=let\ rec\ ..\ =\ ..\ in
let rec `name^ `_^^ =
    `what^ `...^
and `subname^ `_^^ =
    `subwhat^`...^
in


XPT if hint=if\ ..\ then\ ..\ else\ ..
if `cond^
    then `thenexpr^`else...^
    else \`cursor\^^^


XPT match hint=match\ ..\ with\ [..\ ->\ ..\ |\ ..]
match `expr^ with
  [ `what0^ -> `with0^`...^
  | `what^ -> `with^`...^
  ]


XPT moduletype hint=module\ type\ ..\ =\ sig\ ..\ end
module type `name^ `^^ = sig
    `cursor^
end;


XPT module hint=module\ ..\ =\ struct\ ..\ end
module `name^ `^^ = struct
    `cursor^
end;

XPT while hint=while\ ..\ do\ ..\ done
while `cond^ do
    `cursor^
done

XPT for hint=for\ ..\ to\ ..\ do\ ..\ done
XSET side=Choose(['to', 'downto'])
for `var^ = `val^ `side^ `expr^ do
    `cursor^
done

XPT class hint=class\ ..\ =\ object\ ..\ end
class `_^^ `name^ =
object (self)
    `cursor^
end;


XPT classtype hint=class\ type\ ..\ =\ object\ ..\ end
class type `name^ =
object
   method `field0^ : `type0^`...^
   method `field^ : `type^`...^
end;

            

XPT classtypecom hint=(**\ ..\ *)\ class\ type\ ..\ =\ object\ ..\ end
(** `class_descr^^ *)
class type `name^ =
object
   (** `method_descr^^ *)
   method `field0^ : `type0^`...^
   (** `method_descr2^^ *)
   method `field^ : `type^`...^
end;


XPT typesum hint=type\ ..\ =\ ..\ |\ ..
type `typename^ `typeParams...^\`a\^ ^^=
  [ `constructor^`...^
  | `constructor2^`...^
  ];

            
XPT typesumcom hint=(**\ ..\ *)\ type\ ..\ =\ ..\ |\ ..
(** `typeDescr^ *)
type `typename^ `typeParams...^\`a\^ ^^=
  [ `constructor^ (** `ctordescr^ *)`...^
  | `constructor2^ (** `ctordescr^ *)`...^
  ];


XPT typerecord hint=type\ ..\ =\ {\ ..\ }
type `typename^ `typeParams...^\`a\^ ^^=
    { `recordField^ : `fType^ `...^
    ; `otherfield^ : `othertype^`...^
    };


XPT typerecordcom hint=(**\ ..\ *)type\ ..\ =\ {\ ..\ }
(** `type_descr^ *)
type `typename^ `_^^=
    { `recordField^ : `fType^ (** `desc^ *)`...^
    ; `otherfield^ : `othertype^ (** `desc^ *)`...^
    };

            
XPT try hint=try\ ..\ with\ ..\ ->\ ..
try `expr^
with [ `exc^ -> `rez^`...^
     | `exc2^ -> `rez2^`...^
     ]

XPT val hint=value\ ..\ :\ ..
value `thing^ : 

XPT ty hint=..\ ->\ ..
`t^`...^ -> `t2^`...^

XPT do hint=do\ {\ ..\ }
do {
    `cursor^
}

XPT begin hint=begin\ ..\ end
begin
    `cursor^
end

XPT fun hint=(fun\ ..\ ->\ ..)
(fun `args^ -> `cursor^)

XPT func hint=value\ ..\ :\ ..\ =\ fun\ ..\ ->
value `funName^ : `ty^ =
fun `args^ ->
    `cursor^;

