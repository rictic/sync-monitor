USING: command-line sequences kernel sync-monitor io ;
IN: sync-monitor.pull-sync

: pull-sync-main ( -- )
    (command-line) dup length 1 =
    [ first pull-sync ] [ drop "usage: pull-sync <dirname-to-watch>" print ] if
    ;
    
MAIN: pull-sync-main