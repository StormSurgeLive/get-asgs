#!/usr/bin/env bash

assert_system_req() {
  # OS and version check
  if [[ ! -e /etc/debian_version ]]; then
    echo<<EOF
  $0 will not continue.  This script targets Debian Stretch environments (including Ubuntu based on it).
  Error: can't find '/etc/debian_version'
EOF
    exit 1
  fi
  version=$(cat /etc/debian_version)
  if [[ $(echo "$version >= 9.0" | bc -l) == 0  || $(echo "$version < 10.0" | bc -l) == 0 ]]; then
    echo<<EOF
  $0 will not continue.  This script targets Debian Stretch environments (including Ubuntu based on it).
  Error: detected version '$version' is not of the form, '9.X".
EOF
    exit 1
  fi
}

assert_system_req

echo
read -p "This script creates a new user 'asgs', and installs ASGS in /home/asgs. Continue [y/N]? " continue
if [[ -z "$continue" || "$continue" == "N" ]]; then
  echo ASGS bootstrap cancelled.
  exit 1
fi

echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
apt-get update
apt-get install -y build-essential checkinstall
apt-get install -y libssl-dev libexpat1-dev
apt-get install -y gfortran wget curl vim screen htop tmux git sudo bc
apt-get install -y zip flex gawk procps
apt-get install -y --allow-downgrades zlib1g=1:1.2.8.dfsg-5
apt-get install -y zlib1g-dev

# symlink for /bin/env
ln -s /usr/bin/env /bin/env > /dev/null 2>&1 || echo /usr/bin/env already links to /bin/env

# asgs
useradd -ms /bin/bash asgs
echo "asgs ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# get git repo
su -c 'cd /home/asgs && git clone https://github.com/StormSurgeLive/asgs.git && cd ./asgs && git checkout master' - asgs
su -c "cd /home/asgs/asgs && git config --global user.email \"$GIT_EMAIL\" && git config --global user.name \"$GIT_NAME\""

# assume 'asgs' user is the only "ASGS" user on the system, if this is not
# sufficient please let us know ...

mkdir /work
mkdir /scratch
chmod 777 /work /scratch

su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps openmpi"         || echo openmpi         - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi

su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps hdf5"            || echo hdf5            - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps netcdf4"         || echo netcdf4         - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps wgrib2"          || echo wgrib2          - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps cpra-postproc"   || echo cpra-postproc   - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps output"          || echo output          - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps util"            || echo util            - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps input-mesh"      || echo input-mesh      - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps input-nodalattr" || echo input-nodalattr - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps perl"            || echo perl            - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps perl-modules"    || echo perl-modules    - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps image-magick"    || echo image-magick    - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps python3"         || echo python3         - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps ffmpeg"          || echo ffmpeg          - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps gnuplot"         || echo gnuplot         - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps units"           || echo units           - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps nco"             || echo nco             - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi
su -c 'cd /home/asgs/asgs && ./init-asgs.sh -b -x "--run-steps pigz"            || echo pigz           - something went wonky but preserving docker image' - asgs
if [ $? != 0 ]; then
  exit 1
fi

# final pass to ensure files are owned by the asgs 
su -c 'cp /home/asgs/asgs/cloud/VirtualBox/oracle-linux-8.7/default.asgs-global.conf /home/asgs/asgs-global.conf' - asgs
su -c 'cp /home/asgs/asgs/cloud/VirtualBox/oracle-linux-8.7/dot.tmux.conf /home/asgs/.tmux.conf' - asgs

chmod 600 /home/asgs/asgs-global.conf

echo<<EOF
Thank you for bootstrapping ASGS on Ubuntu (stretch)!

Next steps:

1. sudo su - asgs
2. cd ./asgs
3. ./asgsh
4. ... use ASGS as expected - maybe try to compile ADCIRC with 'build adcirc'

(please report bugs or surprising behavior)
EOF
