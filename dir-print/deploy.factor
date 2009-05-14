USING: tools.deploy.config ;
H{
    { deploy-unicode? f }
    { deploy-word-props? f }
    { deploy-ui? f }
    { deploy-compiler? t }
    { deploy-threads? t }
    { deploy-io 2 }
    { deploy-name "sync-monitor.dir-print" }
    { deploy-c-types? f }
    { "stop-after-last-window?" t }
    { deploy-word-defs? f }
    { deploy-reflection 1 }
    { deploy-math? t }
}
