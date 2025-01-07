#!/bin/bash
# cur=$(cd "$(dirname "$0")"; pwd)
cur=$(dirname $(readlink -f "$0"))
source /etc/profile
export |grep DOCKER_REG |grep -Ev "PASS|PW"
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo
repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub


function doBuildx(){
    local tag=$1
    local dockerfile=$2

    repo=registry-1.docker.io
    # repo=registry.cn-shenzhen.aliyuncs.com
    test ! -z "$REPO" && repo=$REPO #@gitac
    img="docker-libvirtd:$tag"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="docker-libvirtd:$tag-cache" #tag-cache
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    
    # plat="--platform linux/amd64,linux/arm64,linux/arm"
    plat="--platform linux/amd64,linux/arm64" ##,linux/arm

    compile="alpine-compile";
    # test "$plat" != "--platform linux/amd64,linux/arm64,linux/arm" && compile="${compile}-dbg"
    # --build-arg REPO=$repo/ #temp notes, just use dockerHub's
    args="""
    --provenance=false 
    --build-arg REPO=$repo/
    --build-arg COMPILE_IMG=$compile
    --build-arg NOCACHE=$(date +%Y-%m-%d_%H:%M:%S)
    """

    # cd flux
    # test "$plat" != "--platform linux/amd64,linux/arm64,linux/arm" && img="${img}-dbg"
    # test "$plat" != "--platform linux/amd64,linux/arm64,linux/arm" && cimg="${cimg}-dbg"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"
    output="--output type=image,name=$repo/$ns/$img,push=true,oci-mediatypes=true,annotation.author=sam"
    docker buildx build $cache $plat $args $output -f $dockerfile . 
}

cd $cur/
ns=infrastlabs
ver=v51 #base-v5 base-v5-slim
doBuildx v2501-alpine319 Dockerfile #latest> v2501
