module swap PrgEnv-cray PrgEnv-gnu

module swap gcc gcc/6.1.0

module load cmake/3.5.2

module load fftw

module load boost/1.60

module load metis

export OPT_DIR=/work/n08/n08/shared/opt

export EIGEN3_ROOT=${OPT_DIR}/eigen

export EXODUS_ROOT=${OPT_DIR}/ExodusII/seacas-exodus

export HDF5_ROOT=${EXODUS_ROOT}

export METIS_ROOT=/work/y07/y07/cse/metis/5.1.0-32bit

export CRAYPE_LINK_TYPE=dynamic
