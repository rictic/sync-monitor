USING: command-line sequences kernel io.files.info accessors calendar arrays io.directories hashtables json.writer io.pathnames sync-monitor io ;
IN: sync-monitor.dir-print 

: dir-print-main ( -- )
    (command-line) [ dir-print-mtimes "\n" print ] each 
    ;
    
MAIN: dir-print-main