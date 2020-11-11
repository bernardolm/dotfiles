function sanitize_vscode() {
    /bin/rm -rf ~/.config/Code/Backups
    /bin/rm -rf ~/.config/Code/blob_storage
    /bin/rm -rf ~/.config/Code/Cache
    /bin/rm -rf ~/.config/Code/CachedData
    /bin/rm -rf ~/.config/Code/GPUCache
    /bin/rm -rf ~/.config/Code/logs
    /bin/rm -rf ~/.config/Code/webrtc_event_logs
}
