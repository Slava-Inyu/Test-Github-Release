version="0.0.9"
description="


### Bug fixes

* update tests
"
new_description=$(echo "$description" | awk 'BEGIN{RS="\n";ORS="\\n"}1')
echo -e "$new_description"

# Create and push tags
git tag "${version}" master
git push origin "${version}"

# Make github release
github_account="Slava-Inyu"
github_repo_name="test-github-release"
github_auth_token="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"
auth_header="Authorization: token ${github_auth_token}"

github_api="https://api.github.com/repos/${github_account}/${github_repo_name}"

function status_check {
  local status_code="${1}"

   case "$status_code" in
    "401")
      echo "Error: Authentication token is not valid"
      exit 1 
      ;;
    "422")
      echo "Error: Couldn't create new relese - release already exists"
      exit 1
      ;;
    "200")
      echo "Success: Token is valid" 
      ;;
    "201")
      echo "Success: Release was successfully created" 
      ;;
    *)
      echo "Error: Something went wrong while creating new release, status code ${status_code}"
      ;;
  esac
}


# Validate token
response_status=$(curl -sH "${auth_header}" -I "${github_api}" | awk -F " " 'NR==1{print $2}')
status_check $response_status

# Create release
github_api_release="${github_api}/releases"
json_data="{\"tag_name\": \"$version\", \"name\": \"$github_repo_name\", \"body\": \"$new_description\" }"

response_status=$(curl -o /dev/null -sH "${auth_header}" --write-out '%{http_code}' --data "${json_data}" "${github_api_release}")
status_check $response_status
