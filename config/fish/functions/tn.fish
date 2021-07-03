function tn --wraps='npx --no-install ts-node --transpile-only' --description 'alias tn npx --no-install ts-node --transpile-only'
  npx --no-install ts-node --transpile-only $argv; 
end
