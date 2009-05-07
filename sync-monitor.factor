! Copyright (C) 2009 Peter Burns.
! See http://factorcode.org/license.txt for BSD license.
USING: concurrency.mailboxes kernel io.monitors sequences accessors prettyprint locals io.files.info command-line ;
IN: sync-monitor

: print-files-changed ( mailbox -- )
    dup mailbox-get  path>> .
    print-files-changed ;

: sync-monitor ( paths-seq -- )
    <mailbox> tuck swap
    [ swap t swap (monitor) ] with map drop
    print-files-changed ;

