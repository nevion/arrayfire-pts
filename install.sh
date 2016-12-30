#!/bin/sh

# Not all of these dependencies below may be covered automatically by PTS, in particular arrayfire.
# http://arrayfire.com/download-splash/?redirect_to=/download or compile from source from gitub:
# https://github.com/arrayfire/arrayfire
# sudo apt-get install --no-install-recommends libboost-all-dev

if [ -d /usr/local/cuda ]
then
    PATH="/usr/local/cuda/bin:$PATH"
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/nvvm/lib64:$LD_LIBRARY_PATH
    export CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda
fi

if [ ! -e arrayfire-benchmark.git ]
then
    git clone -b wip --recursive --depth=1 https://github.com/nevion/arrayfire-benchmark.git arrayfire-benchmark.git
    pushd arrayfire-benchmark.git
    git co wip
    pushd build
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    make -j${NUM_CPU_CORES}
    echo $? > ~/install-exit-status
    popd
    popd
fi
#pushd arrayfire-benchmark.git
cd ~/
echo "#!/bin/sh
cd arrayfire-benchmark.git
if [ -d /usr/local/cuda ]
then
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/nvvm/lib64:$LD_LIBRARY_PATH
fi
./\$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > arrayfire
chmod +x arrayfire