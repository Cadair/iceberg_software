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
module load libs/gcc/5.2/fftw

############################## Variable Setup ################################
name=CRISPRED
version=2016.04.15
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
GIT_DIR=crispred
if [ -d $GIT_DIR ]
then                                                                            
    cd $GIT_DIR
    git clean -fxd
    git reset --hard HEAD
    git pull origin master
else
    git clone git://dubshen.astro.su.se/jaime/crispred
    cd $GIT_DIR
fi

##############################################################################

##############################################################################
# Installation (Write the install script here)
##############################################################################
ARCH=$(uname -m)
cd creduc
sed -i "s/IDIR =/IDIR ?=/" Makefile

make

mkdir -p $prefix/dlm/$ARCH
IDIR=$prefix/dlm/$ARCH/ make install

cd ../math
sed -i "s%~/idl/dlm%$prefix/dlm%" compile_linux.sh
./compile_linux.sh
