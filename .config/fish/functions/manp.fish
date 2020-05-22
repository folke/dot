function manp -d "Open a specified man page in Preview"
  if [ (count $argv) -gt 0 ]
    man -t $argv | open -f -a Preview
  else
    echo "No arguments given"
  end
end
