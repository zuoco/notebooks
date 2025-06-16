path=$(pwd)
echo "path: $path"
result=$(echo "$path" | sed -E 's!.*/(post/.*)!\1!')
echo "cmd: hugo new $result/index.md"
cd "/home/zci/notebooks"
hugo new  "$result/index.md" 
