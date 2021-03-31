#!/bin/bash
# use on master branch and retag also older tags

# delete all current tags
git fetch --tags --force
tags=()
for t in `git tag`
do
    if [[ "$t" != 4.0* ]]; then
         continue
    fi
    echo "Deleting tag $t"
    git tag -d $t
    git push origin :refs/tags/$t
    tags=("${tags[@]}" "$t")
done
git push origin main
git push origin --tags

# create tags from the list
tags=('5.2');
for t in "${tags[@]}"
do
    echo "Creating tag $t"
    git checkout main
    sed -i -e "s#^[[:space:]]*ZABBIX_VERSION=.*#  ZABBIX_VERSION=$t \\\#" Dockerfile
    sleep 5    
    git add Dockerfile
    sleep 5
    git commit -m "Tag $t"
    sleep 5
    git tag -a $t -m "Tag $t"
    sleep 5
    last=$t        
done
git push origin main
git push origin --tags

# master is the latest stable tag
git checkout main
sed -i -e "s#^[[:space:]]*ZABBIX_VERSION=.*#  ZABBIX_VERSION=5.2 \\\#" Dockerfile
sleep 5
git add Dockerfile
sleep 5
git commit -m "main = the latest stable tag"
git push origin main
