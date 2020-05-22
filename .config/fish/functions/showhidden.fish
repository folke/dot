function showhidden -d "Hides/reveals system files and folders in Finder"
  switch "$argv"
  case Yes YES yes
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder /System/Library/CoreServices/Finder.app
  case No NO no
    defaults write com.apple.finder AppleShowAllFiles NO
    killall Finder /System/Library/CoreServices/Finder.app
  case '*'
    echo "Command input must be 'yes' or 'no'"
  end
end
