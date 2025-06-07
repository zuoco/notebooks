path=$(pwd)
echo $path
result=$(echo "$path" | sed -E 's!.*/(post/.*)!\1!')
echo $result
cd "/home/zcli/notebooks"
hugo new  "$result/index.md" 
