#!/bin/bash

# ---------------------------------------------
# clone pybind11 into library directory

cd ants/lib # go to lib dir
if [[ -d ~/pybind11 ]]; then
    rm rf ~/pybind11
fi 
git clone https://github.com/ncullen93/pybind11.git
cd ../../ # go back to main dir

# ---------------------------------------------
# create local ~/.antspy dir and move package data to it

if [[ -d ~/.antspy ]]; then 
    rm rf ~/.antspy
fi
mkdir ~/.antspy
cp data/* ~/.antspy/

# ---------------------------------------------
# clone ANTs and move all files into library directory

antsgit=https://github.com/ANTsX/ANTs.git
antstag=fb874ebe977b84b57b7c5a2b124608f748e8e1e2 # pixeltype in resampleImage

cd ants/lib # go to lib dir

# if antscore doesnt exist, create it
if [[ ! -d antscore ]] ; then
    git clone $antsbranch $antsgit antsrepo

    if [[ ! -d antscore ]] ; then
        mkdir antscore
    fi

    cd antsrepo # go to antscore
    # check out right branch
    if [[ -d .git ]]; then
        git checkout master
        git pull
        git checkout $antstag
    fi
    cd ..
    # copy antscore files into library
    cp -r antsrepo/Examples/*  antscore/
    cp -r antsrepo/Examples/include/*  antscore
    cp -r antsrepo/ImageRegistration/*  antscore/
    cp -r antsrepo/ImageSegmentation/*  antscore/
    cp -r antsrepo/Tensor/*  antscore/
    cp -r antsrepo/Temporary/*  antscore/
    cp -r antsrepo/Utilities/*  antscore/


    rm -rf antsrepo # remove directory

    # lil hack bc of stupid angled import bug in actual files
    cp ReadWriteData.h antscore/ReadWriteData.h
    # lil hack bc ANTsVersionConfig.h is only created if you build ANTs...
    cp ANTsVersionConfig.h antscore/ANTsVersionConfig.h
fi

cd  ../../ # go back to main dir




