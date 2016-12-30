#!/bin/sh

# Not all of these dependencies below may be covered automatically by PTS, in particular arrayfire.
# http://arrayfire.com/download-splash/?redirect_to=/download or compile from source from gitub:
# https://github.com/arrayfire/arrayfire
# sudo apt-get install --no-install-recommends libboost-all-dev

#ArrayFire is expected to be installed to /opt
#to install via the shell package ArrayFire supplies - use the prefix option ./ArrayFire-v3.4.2_Linux_x86_64.sh --prefix=/opt
#when prompted with "Do you want to include the subdirectory arrayfire-3?", say yes

#launch with the environment variable OpenCL_INCLUDE_DIR set to the path to cl.h
#e.g. OpenCL_INCLUDE_DIR=/opt/rocm/opencl/include/CL/ phoronix-test-suite install arrayfire
#also make sure to use the correct path to your OpenCL shared library
#e.g. LD_LIBRARY_PATH=/opt/rocm/opencl/lib/x86_64 phoronix-test-suite run arrayfire

if [ -d /usr/local/cuda ]
then
    PATH="/usr/local/cuda/bin:$PATH"
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/nvvm/lib64:$LD_LIBRARY_PATH
    export CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda
    if [ -n OpenCL_INCLUDE_DIR ]
    then
        export OpenCL_INCLUDE_DIR=/usr/local/cuda/include/CL
    fi
fi

if [ ! -e arrayfire-benchmark.git ]
then
    git clone -b wip --recursive --depth=1 https://github.com/nevion/arrayfire-benchmark.git arrayfire-benchmark.git
fi
if [ ! -e arrayfire-benchmark.git/bin/benchmark_opencl ]
then
    pushd arrayfire-benchmark.git
    #git checkout wip
    pushd build
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DArrayFire_DIR=/opt/arrayfire-3/share/ArrayFire/cmake -DOpenCL_INCLUDE_DIR=${OpenCL_INCLUDE_DIR} ..
    #make -j${NUM_CPU_CORES} benchmark_opencl
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
if [ -n COMPUTE_DEVICE ]
then
   export COMPUTE_DEVICE=0
fi
timeout -s SIGKILL --preserve-status 30 ./\$@ -d \${COMPUTE_DEVICE} > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > arrayfire
chmod +x arrayfire
