! Copyright (C) 2004, 2005 Slava Pestov.
! See http://factor.sf.net/license.txt for BSD license.
IN: assembler

DEFER: compile-call-label ( label -- )
DEFER: compile-jump-label ( label -- )

IN: compiler
USING: assembler errors inference kernel lists math namespaces
sequences strings vectors words ;

: generate-code ( word linear -- length )
    compiled-offset >r
    compile-aligned
    swap save-xt
    [ generate-node ] each
    compile-aligned
    compiled-offset r> - ;

: generate-reloc ( -- length )
    relocation-table get
    dup [ compile-cell ] seq-each
    length cell * ;

: (generate) ( word linear -- )
    #! Compile a word definition from linear IR.
    100 <vector> relocation-table set
    begin-assembly swap >r >r
        generate-code
        generate-reloc
    r> set-compiled-cell
    r> set-compiled-cell ;

SYMBOL: previous-offset

: generate ( word linear -- )
    #! If generation fails, reset compiled offset.
    [
        compiled-offset previous-offset set
        (generate)
    ] [
        [
            previous-offset get set-compiled-offset
            rethrow
        ] when*
    ] catch ;

! A few VOPs have trivial generators.

M: %label generate-node ( vop -- )
    vop-label save-xt ;

M: %end-dispatch generate-node ( vop -- ) drop ;

: compile-call ( word -- ) dup postpone-word compile-call-label ;

M: %call generate-node vop-label compile-call ;

M: %jump-label generate-node vop-label compile-jump-label ;

: compile-target ( word -- ) 0 compile-cell absolute ;

M: %target-label generate-node vop-label compile-target ;

M: %target generate-node
    vop-label dup postpone-word  compile-target ;
