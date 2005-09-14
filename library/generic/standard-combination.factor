IN: generic
USING: errors hashtables kernel kernel-internals lists math
namespaces sequences vectors words ;

: error-method ( picker word -- method )
    [ swap % literalize , \ no-method , ] [ ] make ;

: empty-method ( picker word -- method )
    over [ dup ] = [
        [
            [ dup delegate ] % dup unit , error-method , \ ?ifte ,
        ] [ ] make
    ] [
        error-method
    ] ifte ;

: class-predicates ( picker assoc -- assoc )
    [ uncons >r "predicate" word-prop append r> cons ] map-with ;

: alist>quot ( default alist -- quot )
    [ unswons [ % , , \ ifte , ] [ ] make ] each ;

: sort-methods ( assoc -- vtable )
    #! Input is a predicate -> method association.
    num-types [
        type>class [ object ] unless*
        swap [ car classes-intersect? ] subset-with
    ] map-with ;

: simplify-alist ( class alist -- default alist )
    dup cdr [
        2dup cdr car car class< [
            cdr simplify-alist
        ] [
            uncons >r cdr nip r>
        ] ifte
    ] [
        nip car cdr [ ]
    ] ifte ;

: vtable-methods ( picker alist-seq n -- alist-seq )
    [
        type>class [ object ] unless*
        swap simplify-alist
        >r over r> class-predicates alist>quot
    ] 2map nip ;

: <vtable> ( picker word n -- vtable )
    #! n is vtable size; either num-types or num-tags.
    >r 2dup empty-method \ object swons >r methods r> swons
    sort-methods r> vtable-methods ;

: small-generic ( picker word -- def )
    2dup methods class-predicates >r empty-method r> alist>quot ;

: big-generic ( picker word n dispatcher -- def )
    [ >r pick % r> , <vtable> , \ dispatch , ] [ ] make ;

: tag-generic? ( word -- ? )
    "methods" word-prop hash-keys [ types ] map concat
    [ tag-mask < ] all? ;

: small-generic? ( word -- ? )
    "methods" word-prop hash-size 3 <= ;

: standard-combination ( word picker -- quot )
    swap dup tag-generic? [
        num-tags \ tag big-generic
    ] [
        dup small-generic? [
            small-generic
        ] [
            num-types \ type big-generic
        ] ifte
    ] ifte ;

: simple-combination ( word -- quot )
    [ dup ] standard-combination ;

: define-generic ( word -- )
    [ simple-combination ] define-generic* ;

PREDICATE: generic simple-generic ( word -- ? )
    "combination" word-prop [ simple-combination ] = ;
