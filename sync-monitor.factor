! Copyright (C) 2009 Peter Burns.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors arrays assocs calendar command-line
concurrency.mailboxes hashtables io io.directories
io.files.info io.monitors io.pathnames json.writer kernel
locals prettyprint sequences threads ;
IN: sync-monitor

: modified-time ( path -- mtime )
    link-info modified>> timestamp>millis
    ;

: modified-time-pair ( path -- path-mtime-pair )
    dup modified-time 2array
    ;

: get-file-mtime-pairs ( path -- assoc )
    dup directory-files
    [ over prepend-path dup link-info directory? [ get-file-mtime-pairs ] [ modified-time-pair ] if ] map 
    >hashtable
    2array
    ;
: dir-print-mtimes ( path -- )
    dup get-file-mtime-pairs 1array >hashtable at* drop json-print
    ;



: (build-hash) ( hash mailbox -- )
    2dup 
    mailbox-get path>> dup modified-time swap rot set-at
    (build-hash) ;

: build-hash ( mailbox -- hash )
    H{ } clone tuck swap
    [ (build-hash) ] 2curry  "Building hashtable from filesystem events"
    spawn drop ;


: monitor-mailbox ( monitor mailbox -- )
    2dup 
    next-change swap mailbox-put
    monitor-mailbox ;

: sync-mailbox ( path -- mailbox )
    <mailbox> tuck swap [ t <monitor> monitor-mailbox ] 2curry [ with-monitors ] curry "monitor-mailbox" spawn drop
    ;



: print-files-changed ( mailbox -- )
    dup mailbox-get path>>
    modified-time-pair 1array >hashtable json-print
    "\n" write
    print-files-changed ;


: pull-sync ( path -- )
    sync-mailbox
    build-hash 
    [ dup clone swap clear-assoc json-print drop ] curry
    each-line
    ;

: push-sync ( path -- )
    sync-mailbox
    print-files-changed
    ;
