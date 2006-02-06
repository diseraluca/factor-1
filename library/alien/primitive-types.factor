USING: alien compiler-backend kernel kernel-internals
math namespaces ;

[
    [ alien-unsigned-cell <alien> ] "getter" set
    [
        >r >r alien-address r> r> set-alien-unsigned-cell
    ] "setter" set
    bootstrap-cell "width" set
    bootstrap-cell "align" set
    [ "box_alien" %box ] "boxer" set
    [ "unbox_alien" %unbox ] "unboxer" set
] "void*" define-primitive-type

[
    [ alien-signed-8 ] "getter" set
    [ set-alien-signed-8 ] "setter" set
    8 "width" set
    8 "align" set
    [ "box_signed_8" %box ] "boxer" set
    [ "unbox_signed_8" %unbox ] "unboxer" set
] "longlong" define-primitive-type

[
    [ alien-unsigned-8 ] "getter" set
    [ set-alien-unsigned-8 ] "setter" set
    8 "width" set
    8 "align" set
    [ "box_unsinged_8" %box ] "boxer" set
    [ "unbox_unsigned_8" %unbox ] "unboxer" set
] "ulonglong" define-primitive-type

[
    [ alien-signed-cell ] "getter" set
    [ set-alien-signed-cell ] "setter" set
    bootstrap-cell "width" set
    bootstrap-cell "align" set
    [ "box_signed_cell" %box ] "boxer" set
    [ "unbox_signed_cell" %unbox ] "unboxer" set
] "long" define-primitive-type

[
    [ alien-unsigned-cell ] "getter" set
    [ set-alien-unsigned-cell ] "setter" set
    bootstrap-cell "width" set
    bootstrap-cell "align" set
    [ "box_unsigned_cell" %box ] "boxer" set
    [ "unbox_unsigned_cell" %unbox ] "unboxer" set
] "ulong" define-primitive-type

[
    [ alien-signed-4 ] "getter" set
    [ set-alien-signed-4 ] "setter" set
    4 "width" set
    4 "align" set
    [ "box_signed_4" %box ] "boxer" set
    [ "unbox_signed_4" %unbox ] "unboxer" set
] "int" define-primitive-type

[
    [ alien-unsigned-4 ] "getter" set
    [ set-alien-unsigned-4 ] "setter" set
    4 "width" set
    4 "align" set
    [ "box_unsigned_4" %box ] "boxer" set
    [ "unbox_unsigned_4" %unbox ] "unboxer" set
] "uint" define-primitive-type

[
    [ alien-signed-2 ] "getter" set
    [ set-alien-signed-2 ] "setter" set
    2 "width" set
    2 "align" set
    [ "box_signed_2" %box ] "boxer" set
    [ "unbox_signed_2" %unbox ] "unboxer" set
] "short" define-primitive-type

[
    [ alien-unsigned-2 ] "getter" set
    [ set-alien-unsigned-2 ] "setter" set
    2 "width" set
    2 "align" set
    [ "box_unsigned_2" %box ] "boxer" set
    [ "unbox_unsigned_2" %unbox ] "unboxer" set
] "ushort" define-primitive-type

[
    [ alien-signed-1 ] "getter" set
    [ set-alien-signed-1 ] "setter" set
    1 "width" set
    1 "align" set
    [ "box_signed_1" %box ] "boxer" set
    [ "unbox_signed_1" %unbox ] "unboxer" set
] "char" define-primitive-type

[
    [ alien-unsigned-1 ] "getter" set
    [ set-alien-unsigned-1 ] "setter" set
    1 "width" set
    1 "align" set
    [ "box_unsigned_1" %box ] "boxer" set
    [ "unbox_unsigned_1" %unbox ] "unboxer" set
] "uchar" define-primitive-type

[
    [ alien-unsigned-cell <alien> alien>string ] "getter" set
    [
        >r >r string>alien alien-address r> r>
        set-alien-unsigned-cell
    ] "setter" set
    bootstrap-cell "width" set
    bootstrap-cell "align" set
    [ "box_c_string" %box ] "boxer" set
    [ "unbox_c_string" %unbox ] "unboxer" set
] "char*" define-primitive-type

[
    [ alien-unsigned-4 ] "getter" set
    [ set-alien-unsigned-4 ] "setter" set
    bootstrap-cell "width" set
    bootstrap-cell "align" set
    [ "box_utf16_string" %box ] "boxer" set
    [ "unbox_utf16_string" %unbox ] "unboxer" set
] "ushort*" define-primitive-type

[
    [ alien-unsigned-4 zero? not ] "getter" set
    [ 1 0 ? set-alien-unsigned-4 ] "setter" set
    bootstrap-cell "width" set
    bootstrap-cell "align" set
    [ "box_boolean" %box ] "boxer" set
    [ "unbox_boolean" %unbox ] "unboxer" set
] "bool" define-primitive-type

[
    [ alien-float ] "getter" set
    [ set-alien-float ] "setter" set
    4 "width" set
    4 "align" set
    [ "box_float" %box ] "boxer" set
    [ "unbox_float" %unbox ] "unboxer" set
    T{ float-regs f 4 } "reg-class" set
] "float" define-primitive-type

[
    [ alien-double ] "getter" set
    [ set-alien-double ] "setter" set
    8 "width" set
    8 "align" set
    [ "box_double" %box ] "boxer" set
    [ "unbox_double" %unbox ] "unboxer" set
    T{ float-regs f 8 } "reg-class" set
] "double" define-primitive-type
