#!/bin/bash


#1. Create a folder for your datasets. Usually, multiple users use one folder for all datasets to be able to share them. Later on, in the 
#training and inference scripts, you will need the path to the dataset.
#2. Create the EML tools folder structure, e.g. ```eml-tools```. The structure can be found here: https://github.com/embedded-machine-learning/eml-tools#interface-folder-structure
ROOTFOLDER=`pwd`

#In your root directory, create the structure. Sample code
mkdir eml_projects
mkdir venv

#3. Clone the EML tools repository into your workspace
git clone https://github.com/embedded-machine-learning/eml-tools.git

#4. Create the task spooler script to be able to use the correct task spooler on the device. In our case, just copy
#./init_ts.sh

# Project setup
#1. Go to your project folder and clone the YoloV5 repository. Then rename it for your project.

cd eml_projects/
git clone https://github.com/ultralytics/yolov5.git
mv yolov5 yolov5-oxford-pets

#2. Create a virtual environment for yolov5 in your venv folder. The venv folder is put outside of the project folder to 
#avoid copying lots of small files when you copy the project folder. Conda would also be a good alternative.
# From root
cd $ROOTFOLDER

cd ./venv
virtualenv -p python3.8 yolov5_py38
source yolov5_py38/bin/activate

# Install necessary libraries
python -m pip install --upgrade pip
pip install --upgrade setuptools cython wheel

# Install yolov5 libraries
cd ../eml_projects/yolov5-oxford-pets/
pip install -r requirements.txt

# Install EML libraries
pip install lxml xmltodict tdqm beautifulsoup4 pycocotools

# Install OpenVino libraries
pip install onnx-simplifier networkx defusedxml requests

# Activate YoloV5 environment
source ./venv/yolov5_py38/bin/activate