! :folding=indent:collapseFolds=1:

! $Id$
!
! Copyright (C) 2004 Slava Pestov.
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
! 
! 1. Redistributions of source code must retain the above copyright notice,
!    this list of conditions and the following disclaimer.
! 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
! 
! THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
! INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
! FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
! DEVELOPERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
! SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
! PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
! OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
! WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
! OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
! ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

IN: file-responder
USE: combinators
USE: errors
USE: files
USE: httpd
USE: httpd-responder
USE: kernel
USE: logging
USE: namespaces
USE: parser
USE: stack
USE: stdio
USE: streams
USE: strings

: serving-path ( filename -- filename )
    f>"" "doc-root" get swap cat2 ;

: file-header ( mime-type -- header )
    "200 Document follows" swap response ;

: copy-and-close ( from -- )
    [ dupd "stdio" get fcopy ] [ >r fclose r> rethrow ] catch ;

: serve-static ( filename mime-type -- )
    file-header print <filebr> "stdio" get fcopy ;

: serve-file ( filename -- )
    dup mime-type dup "application/x-factor-server-page" = [
        drop run-file
    ] [
        serve-static
    ] ifte ;

: directory-no/ ( -- )
    <% "request" get % CHAR: / %
    "raw-query" get [ CHAR: ? % % ] when*
    %> redirect ;

: serve-directory ( filename -- )
    dup "/" str-tail? dup [
        drop dup "index.html" cat2 dup exists? [
            serve-file
        ] [
            drop
            "Foo bar" log
            drop
        ] ifte
    ] [
        2drop directory-no/
    ] ifte ;

: serve-object ( filename -- )
    dup directory? [ serve-directory ] [ serve-file ] ifte ;

: file-responder ( filename -- )
    "doc-root" get [
        serving-path dup exists? [
            serve-object
        ] [
            drop "404 not found" httpd-error
        ] ifte
    ] [
        drop "404 doc-root not set" httpd-error
    ] ifte ;
