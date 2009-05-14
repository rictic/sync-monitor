! Copyright (C) 2009 Peter Burns.
! See http://factorcode.org/license.txt for BSD license.
USING: concurrency.mailboxes kernel io.monitors sequences accessors prettyprint locals io.files.info command-line calendar assocs threads json.writer io arrays hashtables io.directories ;
IN: sync-monitor

: (build-hash) ( hash mailbox -- )
    2dup mailbox-get path>> dup
    link-info modified>> timestamp>micros swap rot set-at
    (build-hash) ;

: build-hash ( mailbox -- hash )
    H{ } clone tuck swap
    [ (build-hash) ] 2curry  "Building hashtable from filesystem events"
    spawn drop ;


: sync-mailbox ( path -- mailbox )
    <mailbox> tuck swap
    [ swap t swap (monitor) ] with map drop ;

: modified-time-pair ( path -- path-mtime-pair )
    dup link-info modified>> timestamp>micros
    2array
    ;


: get-file-mtime-pairs ( pair -- assoc )
    dup 
    [ 
        [ dup link-info directory? [ get-file-mtime-pairs ] [ modified-time-pair ] if ] map 
    ] with-directory-files
    >hashtable
    2array
    ;
: dir-print-mtimes ( path -- )
    get-file-mtime-pairs 1array >hashtable json-print
    ;

: print-files-changed ( mailbox -- )
    dup mailbox-get path>>
    modified-time-pair 1array >hashtable json-print
    "\n" write
    print-files-changed ;



: monitor-mailbox ( monitor mailbox -- )
    2dup 
    next-change swap mailbox-put
    monitor-mailbox ;

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
