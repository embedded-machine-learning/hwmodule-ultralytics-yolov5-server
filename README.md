# Training and Inference of Ultralytics YoloV5 on a Linux Server with EML Tools
In this folder, there is a template project for inference of trained, exported models of YoloV5 on a training server. In the following
procedure, instructions are provided to setup and run one or more networks and to extract the evaluations of the executions. All
evaluations are compatible with the EML tools.

## Setup

### Prerequisites
1. Setup the task spooler on the target device. Instructions can be found here: https://github.com/embedded-machine-learning/scripts-and-guides/blob/main/guides/task_spooler_manual.md

### Dataset
For validating the tool chain, download the small validation set from kaggle: https://www.kaggle.com/alexanderwendt/oxford-pets-cleaned-for-eml-tools

It contains of two small sets that are used for training and inference validation in the structure that is compatible to the EML Tools. 
Put it in the following folder structure, e.g. ```/srv/cdl-eml/datasets/dataset-oxford-pets-cleaned/```

### Generate EML Tools directory structure
The following steps are only necessary if you setup the EML tools for the first time on a device.
1. Create a folder for your datasets. Usually, multiple users use one folder for all datasets to be able to share them. Later on, in the 
training and inference scripts, you will need the path to the dataset.

2. Create the EML tools folder structure, e.g. ```eml-tools```. The structure can be found here: https://github.com/embedded-machine-learning/eml-tools#interface-folder-structure. 
Most of the following steps are performed with this script as well: ```generate_workspace.sh```

In your root directory, create the structure. Sample code
```
mkdir eml_projects
mkdir venv

```
3. Clone the EML tools repository into your workspace
```
git clone https://github.com/embedded-machine-learning/eml-tools.git
```
4. Create the task spooler script to be able to use the correct task spooler on the device. In our case, just copy
```./init_ts.sh``` to the workspace root. The idea is that all projects will use this task spooler.

### Project setup
1. Go to your project folder and clone the YoloV5 repository. Then rename it for your project.
```
cd eml_projects/
git clone https://github.com/ultralytics/yolov5.git
mv yolov5 yolov5-oxford-pets
```

2. Create a virtual environment for yolov5 in your venv folder. The venv folder is put outside of the project folder to 
avoid copying lots of small files when you copy the project folder. Conda would also be a good alternative.

```
# From root
cd ./venv
virtualenv -p python3.8 yolov5_pv38
source yolov5_pv38/bin/activate

# Install necessary libraries
python -m pip install --upgrade pip
pip install --upgrade setuptools cython wheel

# Install yolov5 libraries
cd ../eml_projects/yolov5-oxford-pets/
pip install -r requirements.txt

# Install EML libraries
pip install lxml xmltodict tdqm beautifulsoup4 pycocotools

# Install OpenVino libraries
pip install onnx-simplifier networkx defusedxml

```

4. Copy the scripts from this folder to your project folder and execute ```chmod 777 *.sh``` in the yolov5 folder, inside of the reporsitory

5. Execute ```setup_dirs.sh``` to create all necessary sub folders

### Setup Training Configuration
To train a network, the following files need to be created within the YoloV5 repository: [YOLODATA].yaml, [YOLOVERSION].yaml [YOLOWEIGHTS].pt. They are used in ```train.py```.
```
python train.py \
  --data $YOLODATA.yaml \
  --cfg $YOLOVERSION.yaml \
  --hyp data/hyps/hyp.scratch.yaml \
  --weights ./weights/$YOLOWEIGHTS.pt \
  --name $MODELNAME \
  --exist-ok \
  --batch-size $BATCHSIZE \
  --img $YOLOIMGSIZE \
  --epochs $EPOCHS
```

[YOLODATA].yaml shall be added to ```./data``` and they are specific for locating the dataset. In ```./data```, there are two samples for our Oxford Pets Reduced dataset.

[YOLOVERSION].yaml shall be added to ```./models``` and contains the configuration of the network. In ```./models```, a sample for the Oxtford Pets Dataset can be found.

[YOLOWEIGHTS].pt contains the pretrained weights for all models that are used. They have to be downloaded from the yolov5 page.

### Modification of script files
The next step is to adapt the script files to the current environment.

#### Adapt Task Spooler Script
In ```init.ts.sh```, either adapt

```
export TS_SOCKET="/srv/ts_socket/CPU.socket"
chmod 777 /srv/ts_socket/CPU.socket
``` 

to your task spooler path or call another task spooler script in your EML Tools root.
```
. ../../init_eda_ts.sh
```

In ```init_env.sh```, adapt the ```source ../../venv/yolov5_pv38/bin/activate``` to your venv folder or conda implementation.

#### Training and Inference Script
The script ```pt_yolov5_train_export_inf_TEMPLATE.sh``` trains and executes the model in the TEMPLATE on pytorch. 

For training, TEMPLATE has to be replaced by the network name that shall be trained. First copy ```pt_yolov5_train_export_inf_TEMPLATE.sh``` and rename it to fit 
your network, e.g. ```pt_yolov5_train_export_inf_pt_yolov5s_640x360_oxfordpets_e1.sh```. The network correpsonds to the settings below.

For each network to be trained, the following constants have to be adapted:
```
# Constant Definition
USERNAME=wendt   # Your name
USEREMAIL=alexander.wendt@tuwien.ac.at   # Your Email
#MODELNAME=tf2oda_efficientdetd0_320_240_coco17_pedestrian_all_LR002  # Use only for debugging purposes
SCRIPTPREFIX=../../eml-tools
#Validation dataset (not the training dataset)
DATASET=../../../datasets/dataset-oxford-pets-val-debug
#Hardware name
HARDWARENAME=TeslaV100
# Set this variable true if the network shall be trained, else only inference shall be performed
TRAINNETWORK=true

############################################
### Yolo settings ##########################
############################################
# Yolo network configuration. ./models/[MODEL_NAME].yaml
#YOLOVERSION=yolov5s
#YOLOVERSION=yolov5m
#YOLOVERSION=yolov5l
#YOLOVERSION=yolov5x
YOLOVERSION=yolov5s_pets

# Yolo pretrained weights. Location ./weights/[WEIGHT_NAME].pt.
# Weights for small versions of yolo, image size 640
YOLOWEIGHTS=yolov5s
#YOLOWEIGHTS=yolov5m
#YOLOWEIGHTS=yolov5l
#YOLOWEIGHTS=yolov5x
# Weights for big versions of yolo, image size 1280
#YOLOWEIGHTS=yolov5s6
#YOLOWEIGHTS=yolov5m6
#YOLOWEIGHTS=yolov5l6
#YOLOWEIGHTS=yolov5x6

# Yolo image size. Sizes: 640, 1280
YOLOIMGSIZE=640
#YOLOIMGSIZE=1280
#you only supply the longest dimension, --img 640. The rest is handled automatically.

# Yolo dataset reference. ./data/[DATASET].yaml
YOLODATA=oxford_pets

# Set training batch size
BATCHSIZE=32
EPOCHS=1
```

Put the adapted scripts in ```./jobs```. From there the script can be started.


#### Add Folder Jobs for Pytorch
```add_yolo_folder_train_inference_job.sh``` copies all *.sh files from the ```./jobs``` folder, to yolov5 root and puts them into the task spooler.
No script adaptions are necessary.

## Running the system
Run ```./add_yolo_folder_train_inference_job.sh``` to add all models to the task spooler. The result are trained, exported and inferred models that can be copied
to the embedded target devices.

## Embedded Machine Learning Laboratory

This repository is part of the Embedded Machine Learning Laboratory at the TU Wien. For more useful guides and various scripts for many different platforms visit 
our **EML-Tools**: **https://github.com/embedded-machine-learning/eml-tools**.

Our newest projects can be viewed on our **webpage**: **https://eml.ict.tuwien.ac.at/**