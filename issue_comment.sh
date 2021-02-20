MESSAGE=$1
echo "Message: ${MESSAGE}"
ISSUE_NUMBER=$2
echo "Issue Number: ${ISSUE_NUMBER}"

URI=https://api.github.com
CONTENT_TYPE_HEADER="Content-Type: application/json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

# https://developer.github.com/v3/issues/comments/#create-a-comment
curl -X POST -sSL \
    -d "{\"body\": \"$MESSAGE\"}" \
    -H "${AUTH_HEADER}" \
    -H "${CONTENT_TYPE_HEADER}" \
    "${URI}/repos/${GITHUB_REPOSITORY}/issues/${ISSUE_NUMBER}/comments"
