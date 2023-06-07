#!/usr/bin/env bash

assert_system_req() {
  # no check enforced here
  echo -n
}

assert_system_req

echo
read -p "This script downloads and installs ASGS in $HOME/asgs. Continue [y/N]? " continue
if [[ -z "$continue" || "$continue" == "N" ]]; then
  echo ASGS bootstrap cancelled.
  exit 1
fi

cd $HOME && git clone https://github.com/StormSurgeLive/asgs.git && cd $HOME/asgs && git checkout master

/home/asgs

# assume 'asgs' user is the only "ASGS" user on the system, if this is not
# sufficient please let us know ...

export WORK=$HOME/work
export SCRATCH=$WORK
cd $HOME/asgs

./init-asgs.sh -b -x "--run-steps openmpi"         || echo openmpi         - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps hdf5"            || echo hdf5            - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps netcdf4"         || echo netcdf4         - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps wgrib2"          || echo wgrib2          - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps cpra-postproc"   || echo cpra-postproc   - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps output"          || echo output          - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps util"            || echo util            - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps input-mesh"      || echo input-mesh      - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps input-nodalattr" || echo input-nodalattr - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps perl"            || echo perl            - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps perl-modules"    || echo perl-modules    - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps image-magick"    || echo image-magick    - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps python3"         || echo python3         - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps ffmpeg"          || echo ffmpeg          - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps gnuplot"         || echo gnuplot         - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps units"           || echo units           - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps nco"             || echo nco             - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

./init-asgs.sh -b -x "--run-steps pigz"            || echo pigz           - something went wonky but preserving docker image
if [ $? != 0 ]; then
  exit 1
fi

# final pass to ensure files are owned by the asgs 
cp $HOME/asgs/cloud/VirtualBox/oracle-linux-8.7/default.asgs-global.conf $HOME/asgs-global.conf
cp $HOME/asgs/cloud/VirtualBox/oracle-linux-8.7/dot.tmux.conf $HOME/.tmux.conf

chmod 600 $HOME/asgs-global.conf

echo<<EOF
Thank you for bootstrapping ASGS on Ubuntu (stretch)!

Next steps:

1. cd ./asgs
2. ./asgsh
3. ... use ASGS as expected - maybe try to compile ADCIRC with 'build adcirc'

(please report bugs or surprising behavior)
EOF
