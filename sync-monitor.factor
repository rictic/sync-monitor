! Copyright (C) 2009 Peter Burns.
! See http://factorcode.org/license.txt for BSD license.
USING: concurrency.mailboxes kernel io.monitors sequences accessors prettyprint locals io.files.info command-line calendar assocs threads json.writer io arrays hashtables ;
IN: sync-monitor

: (build-hash) ( hash mailbox -- )
    2dup mailbox-get path>> dup
    link-info modified>> timestamp>micros swap rot set-at
    (build-hash) ;

: build-hash ( mailbox -- hash )
    H{ } clone tuck swap
    [ (build-hash) ] 2curry  "Building hashtable from filesystem events"
    spawn drop ;


: print-files-changed ( mailbox -- )
    dup mailbox-get path>>
    dup link-info modified>> timestamp>micros
    2array 1array >hashtable json-print
    "\n" write
    print-files-changed ;

: sync-mailbox ( paths-seq -- mailbox )
    <mailbox> tuck swap
    [ swap t swap (monitor) ] with map drop ;
    
: pull-sync ( paths-seq -- )
    sync-mailbox
    build-hash 
    [ dup clone swap clear-assoc json-print drop ] curry
    each-line
    ;

: push-sync ( paths-seq -- )
    sync-mailbox
    print-files-changed
    ;
    