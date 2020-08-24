#!/bin/bash

GIT_EMAIL="tommylike@gmail.com"
GIT_VERSION="v0"
TIME_VERSION="1"
IMAGE_VERSION="v0.0.1"
URLPKGFILE="newpkgship.rpm"
PKGFILE="pkgship-0.rpm"

echo $PACKAGE_URL

if hash git 2>/dev/null; then
    GIT_VERSION=$(git rev-parse HEAD)
fi
TIME_VERSION=$(date +%s)

IMAGE_VERSION=$GIT_VERSION.$TIME_VERSION
echo $IMAGE_VERSION

wget -q -O $URLPKGFILE $PACKAGE_URL

if [ -e "$URLPKGFILE" ]  && [ `du -s $URLPKGFILE | awk '{print $1}'` -gt 1 ]; then
    for rpmfile in 'pkgship*.rpm'; do	
        rm -rf $rpmfile
    done
    mv $URLPKGFILE $PKGFILE	    
else
	echo "Use old pkgship file."
    rm -rf $URLPKGFILE
fi

if hash docker 2>/dev/null; then
    docker login -u ap-southeast-1@$DOCKER_USER -p $DOCKER_PASS swr.ap-southeast-1.myhuaweicloud.com    
    docker build -t swr.ap-southeast-1.myhuaweicloud.com/opensourceway/packagemanage:$IMAGE_VERSION .
    docker push swr.ap-southeast-1.myhuaweicloud.com/opensourceway/packagemanage:$IMAGE_VERSION
    docker rmi swr.ap-southeast-1.myhuaweicloud.com/opensourceway/packagemanage:$IMAGE_VERSION    
    docker build -t swr.ap-southeast-1.myhuaweicloud.com/opensourceway/dbgetinit:$IMAGE_VERSION ./dbinit
    docker push swr.ap-southeast-1.myhuaweicloud.com/opensourceway/dbgetinit:$IMAGE_VERSION
    docker rmi swr.ap-southeast-1.myhuaweicloud.com/opensourceway/dbgetinit:$IMAGE_VERSION    
else 
    echo "docker is not installed."
fi

if [ -d "infra-openeuler" ]; then
    rm -rf "infra-openeuler"
fi

if hash git 2>/dev/null; then
    git config --global user.email $GIT_EMAIL
    git config --global user.name $GIT_USER
    git clone https://$GIT_USER:$GIT_PASS@github.com/opensourceways/infra-openeuler
    cd infra-openeuler/applications/package-manage/debug
else
    echo "git is not existing."
fi

if hash kustomize 2>/dev/null; then
    kustomize edit set image opensourceway/packagemanage=swr.ap-southeast-1.myhuaweicloud.com/opensourceway/packagemanage:$IMAGE_VERSION
    kustomize edit set image opensourceway/dbgetinit=swr.ap-southeast-1.myhuaweicloud.com/opensourceway/dbgetinit:$IMAGE_VERSION
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

