export PATH=$DEVEL_DIR/install/sbin:$DEVEL_DIR/install/bin:/opt/ros/kinetic/bin:$PATH
export PKG_CONFIG_PATH=$DEVEL_DIR/install/lib/pkgconfig/:/opt/ros/kinetic/lib/pkgconfig

export PYTHONPATH=$DEVEL_DIR/install/lib/python2.7/site-packages:$DEVEL_DIR/install/lib/python2.7/dist-packages:/opt/ros/kinetic/lib/python2.7/dist-packages:$PYTHONPATH

export LD_LIBRARY_PATH=$DEVEL_DIR/install/lib:$DEVEL_DIR/install/lib64:/opt/ros/kinetic/lib:$LD_LIBRARY_PATH

if [ -f $DEVEL_DIR/install/setup.bash ]; then
    source $DEVEL_DIR/install/setup.bash
else
    source /opt/ros/kinetic/setup.bash
fi
if [ "$ROS_PACKAGE_PATH" = "" ]; then
    export ROS_PACKAGE_PATH=$DEVEL_DIR/install/share:/opt/ros/kinetic/share
fi
