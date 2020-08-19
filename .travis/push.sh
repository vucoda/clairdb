#! /bin/sh

remote_repo=https://${GH_TOKEN}@github.com/${GH_OWNER}/${GH_REPO}.git
branch=db_update

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

setup_repository() {
  # git remote name "origin" appears to not work in travis-ci builds with "remote: Invalid username or password."
  git remote add origin-arbitrary https://${GH_TOKEN}@github.com/${GH_OWNER}/${GH_REPO}.git > /dev/null 2>&1
  #git remote add origini-arbitrary $remote_repo > /dev/null 2>&1
}

delete_branch() {
  #curl -s -H 'Authorization: token '"${GH_TOKEN}"'' https://api.github.com
  #git push origin --delete $branch
  curl -s -X DELETE -H 'Authorization: token '"${GH_TOKEN}"'' https://api.github.com/repos/${GH_OWNER}/${GH_REPO}/git/refs/heads/$branch
}

commit_files() {
  git checkout -b $branch
  git add *.txz
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git push --quiet --set-upstream origin-arbitrary $branch
  #curl --location --output clair-db.txz $(curl -X GET https://api.github.com/repos/${GH_OWNER}/${GH_REPO}/commits/$branch | jq --raw-output .files[0].raw_url)
}

setup_git
setup_repository
delete_branch
commit_files
upload_files
