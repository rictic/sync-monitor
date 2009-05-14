USING: command-line sequences kernel io.files.info accessors calendar arrays io.directories hashtables json.writer io.pathnames ;
IN: sync-monitor.dir-print 

: modified-time-pair ( path -- path-mtime-pair )
    dup link-info modified>> timestamp>millis
    2array
    ;


: get-file-mtime-pairs ( path -- assoc )
    dup directory-files
    [ over prepend-path dup link-info directory? [ get-file-mtime-pairs ] [ modified-time-pair ] if ] map 
    >hashtable
    2array
    ;
: dir-print-mtimes ( path -- )
    get-file-mtime-pairs 1array >hashtable json-print
    ;


: dir-print-main ( -- )
    (command-line) [ dir-print-mtimes ] each 
    ;
    
MAIN: dir-print-main