USING: command-line sequences kernel sync-monitor io ;
IN: sync-monitor.dir-print 

: dir-print-main ( -- )
    (command-line) [ dir-print-mtimes "\n" write flush ] each 
    ;
    
MAIN: dir-print-main