#!/bin/bash
set -ex

declare -a EXTRA_CMAKE_ARGS

# Conditionally append try_run results if cross-compiling
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  EXTRA_CMAKE_ARGS+=(
    -DMPI_RUN_RESULT_C_libver_mpi_normal=0
    -DMPI_RUN_RESULT_CXX_libver_mpi_normal=0
    -DMPI_RUN_RESULT_Fortran_libver_mpi_F08_MODULE=0
  )
fi

cmake -B build -S . \
  ${CMAKE_ARGS} \
  -GNinja \
  -DSIRIUS_CREATE_FORTRAN_BINDINGS="ON" \
  -DSIRIUS_CREATE_PYTHON_MODULE="OFF" \
  -DSIRIUS_USE_DFTD3="OFF" \
  -DSIRIUS_USE_DFTD4="OFF" \
  -DSIRIUS_USE_DLAF="OFF" \
  -DSIRIUS_USE_ELPA="OFF" \
  -DSIRIUS_USE_FP32="OFF" \
  -DSIRIUS_USE_MEMORY_POOL="OFF" \
  -DSIRIUS_USE_MKL="OFF" \
  -DSIRIUS_USE_OPENMP="ON" \
  -DSIRIUS_USE_PUGIXML="ON" \
  -DSIRIUS_USE_SCALAPACK="ON" \
  -DSIRIUS_USE_VDWXC="OFF" \
  "${EXTRA_CMAKE_ARGS[@]}"
cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
