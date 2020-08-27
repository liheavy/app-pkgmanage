#!/bin/bash

GIT_EMAIL="tommylike@gmail.com"
GIT_VERSION="v0"
TIME_VERSION="1"
IMAGE_VERSION="v0.0.1"

echo $WEB_SRC_URL

if hash git 2>/dev/null; then
    GIT_VERSION=$(git rev-parse HEAD)
fi
TIME_VERSION=$(date +%s)

IMAGE_VERSION=$GIT_VERSION.$TIME_VERSION


if [ ! -d "packageship" ]; then
	echo "Download clode failed."
    exit
fi

cd packageship/web-ui

echo "begin to docker build."

if hash docker 2>/dev/null; then
    docker login --username=$DOCKER_USER --password=$DOCKER_PASS
    docker build -t opensourceway/pkgmanageweb:$IMAGE_VERSION .
    docker push opensourceway/pkgmanageweb:$IMAGE_VERSION    
    docker rmi opensourceway/pkgmanageweb:$IMAGE_VERSION   
else 
    echo "docker is not installed."
fi

echo "begin to modify image version to github."

if hash git 2>/dev/null; then
    git config --global user.email $GIT_EMAIL
    git config --global user.name $GIT_USER
    git clone https://$GIT_USER:$GIT_PASS@github.com/opensourceways/infra-openeuler
    cd infra-openeuler/applications/package-manage/release
else
    echo "git is not existing."
fi

if hash kustomize 2>/dev/null; then
    kustomize edit set image opensourceway/pkgmanageweb=opensourceway/pkgmanageweb:$IMAGE_VERSION  
else
    echo "use replace to set image."
fi

if hash git 2>/dev/null; then   
    git add .
    git commit -am "update image to $IMAGE_VERSION"
    git push origin --all
else
    echo "git is not existing."
fi

