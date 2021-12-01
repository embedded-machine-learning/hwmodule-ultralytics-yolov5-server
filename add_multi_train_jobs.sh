#!/bin/sh

# Constant Definition
USERNAME=wendt
USEREMAIL=alexander.wendt@tuwien.ac.at
#MODELNAME=tf2oda_efficientdetd0_320_240_coco17_pedestrian_all_LR002
#PYTHONENV=tf24
#BASEPATH=.
#SCRIPTPREFIX=~/tf2odapi/scripts-and-guides/scripts/training
CURRENTFOLDER=`pwd`

echo "Setup task spooler socket."
. ~/init_eda_ts.sh

#NAME1=pt_yolov5s_train_export_pt_yolov5s_640x360_peddet.sh
#NAME2=pt_yolov5s_train_export_pt_yolov5s_1280x720_peddet.sh
#NAME3=pt_yolov5_train_export_pt_yolov5m_640x360_peddet.sh
#NAME4=pt_yolov5_train_export_pt_yolov5m_1280x720_peddet.sh
#NAME5=pt_yolov5_train_export_pt_yolov5l_640x360_peddet.sh
#NAME6=pt_yolov5_train_export_pt_yolov5l_1280x720_peddet.sh
#NAME7=pt_yolov5_train_export_pt_yolov5x_640x360_peddet.sh
NAME8=pt_yolov5_train_export_pt_yolov5x_1280x720_peddet.sh

echo "Add task spooler jobs to the task spooler"
#ts -L AW_$NAME1 $CURRENTFOLDER/$NAME1
#ts -L AW_$NAME2 $CURRENTFOLDER/$NAME2
#ts -L AW_$NAME3 $CURRENTFOLDER/$NAME3
#ts -L AW_$NAME4 $CURRENTFOLDER/$NAME4
#ts -L AW_$NAME5 $CURRENTFOLDER/$NAME5
#ts -L AW_$NAME6 $CURRENTFOLDER/$NAME6
#ts -L AW_$NAME7 $CURRENTFOLDER/$NAME7
ts -L AW_$NAME8 $CURRENTFOLDER/$NAME8

