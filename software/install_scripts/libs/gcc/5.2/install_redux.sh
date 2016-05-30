#!/bin/bash

# This is a template script for building and installing software on iceberg.
# You should use it to document how you install things.
# You will need to configure any module loads the build needs and then 
# configure the variables for the build.
# This script will then create the directories you need and download and unzip
# the source in to the build dir.


############################# Module Loads ###################################
module load compilers/gcc/5.2
module load apps/idl/8.5
module load libs/gcc/5.2/fftw/3.3.4
module load libs/gcc/5.2/boost/1.59

############################## Variable Setup ################################
name=redux
version=2016.05.16
prefix=/usr/local/packages6/libs/gcc/5.2/$name/$version
build_dir=/scratch/$USER/$name

# Set this to 'sudo' if you want to create the install dir using sudo.
sudo=''


##############################################################################
# This should not need modifying
##############################################################################

# Create the build dir

if [ ! -d $build_dir ]
then
    mkdir -p $build_dir
fi

cd $build_dir

# Create the install directory
if [ ! -d $prefix ]
then
   $sudo mkdir -p $prefix
   $sudo chown $USER:app-admins $prefix
fi 

# Download the source
GIT_DIR=redux
if [ -d $GIT_DIR ]
then                                                                            
    cd $GIT_DIR
    git clean -fxd
    git reset --hard HEAD
    git pull origin master
else
    git clone git://dubshen.astro.su.se/hillberg/$GIT_DIR
    cd $GIT_DIR
fi

##############################################################################

##############################################################################
# Installation (Write the install script here)
##############################################################################
ARCH=$(uname -m)
BOOST=/usr/local/packages6/libs/gcc/4.8.2/boost/1.58.0

mkdir build
cd build
cmake ../ -DIDL_DLM_DIR:STRING=$prefix/dlm/$ARCH -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_LIBRARY_PATH:STRING=$BOOST/lib -DCMAKE_INCLUDE_PATH:STRING=$BOOST/include

make GIT_CHECK_LIBREDUX
cd src/dlm/
make -j 8 install
bash
