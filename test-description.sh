version=" 0.0.2"
formatted_version=$(echo "$version" | xargs)
description=$(cat "CHANGELOG.md" | awk -v pattern="# ${formatted_version}" '$0 ~ pattern{flag=1;next}/# [0-9]/{flag=0}flag')
formatted_description=$(echo "$description" | awk 'BEGIN{RS="\n";ORS="\\n"}1')

echo -e "$formatted_description"
