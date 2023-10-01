function plex
    start plexmediaserver
    sleep 1
    and open http://localhost:32400/web/index.html >/dev/null 2>&1
end
