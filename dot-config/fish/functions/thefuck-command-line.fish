function thefuck-command-line
  env THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $history[1] 2> /dev/null | read fuck
  [ -z $fuck ]; and return
  commandline -r $fuck
end
