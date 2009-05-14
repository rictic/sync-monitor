USING: command-line sequences kernel sync-monitor io ;
IN: sync-monitor.push-sync 

: push-sync-main ( -- )
    (command-line) dup length 1 =
    [ first push-sync ] [ drop "usage: push-sync <dirname-to-watch>" print ] if
    ;
    
MAIN: push-sync-main