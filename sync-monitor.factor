! Copyright (C) 2009 Peter Burns.
! See http://factorcode.org/license.txt for BSD license.
USING: concurrency.mailboxes kernel io.monitors sequences accessors prettyprint locals io.files.info command-line calendar assocs ;
IN: sync-monitor

:: (build-hash) ( hash mailbox -- )
    hash
    mailbox mailbox-get path>> dup
    link-info modified>> timestamp>micros set-at
    hash .
    mailbox hash (build-hash) ;

: build-hash ( mailbox -- )
    H{ } clone
    (build-hash) ;


: print-files-changed ( mailbox -- )
    dup mailbox-get  path>> 
    dup link-info modified>> timestamp>micros
    swap . .
    print-files-changed ;

: sync-monitor ( paths-seq -- )
    <mailbox> tuck swap
    [ swap t swap (monitor) ] with map drop
    build-hash ;

