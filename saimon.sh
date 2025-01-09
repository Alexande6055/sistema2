#!/bin/bash
ECHO="echo"
BASE_DIR="/home/proyectos"
CHMOD="chmod"
MKDIR="mkdir"
CHOWN="chown"
TOUCH="touch"
USER_1="user_p1"
USER_2="user_p2"
USER_3="user_p3"

USER_1DIR="proyecto1"
USER_2DIR="proyecto2"
USER_3DIR="proyecto3"

$MKDIR $BASE_DIR/$USER_1DIR
$MKDIR $BASE_DIR/$USER_2DIR
$MKDIR $BASE_DIR/$USER_3DIR

USERADD="useradd"
$USERADD -m -s /bin/bash $USER_1
$USERADD -m -s /bin/bash $USER_2
$USERADD -m -s /bin/bash $USER_3

$CHOWN "$USER_1:$USER_1" $BASE_DIR/$USER_1DIR
$CHOWN "$USER_2:$USER_2" $BASE_DIR/$USER_2DIR
$CHOWN "$USER_3:$USER_3" $BASE_DIR/$USER_3DIR


$TOUCH $BASE_DIR/$USER_1DIR/config_p1.conf
$TOUCH $BASE_DIR/$USER_2DIR/config_p2.conf
$TOUCH $BASE_DIR/$USER_3DIR/config_p3.conf

$CHMOD 700 $USER_1 $USER_2 $USER_3
