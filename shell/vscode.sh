function vscode_sanitize() {
    /bin/rm -rf ~/.config/Code/Backups
    /bin/rm -rf ~/.config/Code/blob_storage
    /bin/rm -rf ~/.config/Code/Cache
    /bin/rm -rf ~/.config/Code/CachedData
    /bin/rm -rf ~/.config/Code/Code\ Cache
    /bin/rm -rf ~/.config/Code/GPUCache
    /bin/rm -rf ~/.config/Code/logs
    /bin/rm -rf ~/.config/Code/Session\ Storage
    /bin/rm -rf ~/.config/Code/webrtc_event_logs
    /bin/rm -rf ~/.vscode/Code/Crash\ Reports
    /bin/rm -rf ~/.vscode/Code/exthost\ Crash\ Reports
    /bin/rm -rf ~/.vscode/Code/Local\ Storage
}
