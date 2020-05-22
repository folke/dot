function flushdns -d "Flushes OS X DNS cache"
  sudo killall -HUP mDNSResponder
end
