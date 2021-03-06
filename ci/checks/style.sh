#!/bin/bash
#
# Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.
#

# Ignore errors and set path
set -e

# Logger function for build status output
function logger() {
  echo -e "\n>>>> $@\n"
}

################################################################################
# Init
################################################################################

PATH=/conda/bin:$PATH

# Set home to the job's workspace
export HOME=$WORKSPACE

cd ${WORKSPACE}

source ci/common/prep-init-env.sh ${WORKSPACE}

################################################################################
# SDK style check
################################################################################

# Run copyright header check
logger "Run Copyright header check..."
./ci/checks/check_copyright.py

# Python
logger "Run Python/Cython formatting check..."
python -m pip install -r ./ci/checks/python-style-requirements.txt
source pyclaragenomics/style_check

logger "Run Python documentation generation..."
mkdir -p pyclaragenomics/docs; cd pyclaragenomics/docs
sphinx-quickstart -p "Clara Genomics Analysis SDK" -v "x.y.z" -a "NVIDIA Corportation" -q --ext-autodoc --sep
##### Update sphinx conf.py with path for modules
sed -i '1s@^@import sys \n@' source/conf.py
sed -i '2s@^@sys.path.insert\(0, "'$PWD'/.."\) \n@' source/conf.py
#####
sphinx-apidoc -f -o source/ ../claragenomics/ ../claragenomics/bindings/*cpython*
make html

# C++
logger "Run C++ formatting check..."
mkdir --parents ${WORKSPACE}/build
cd ${WORKSPACE}/build

cmake .. -DCMAKE_BUILD_TYPE=Release -Dcga_enable_tests=ON -Dcga_enable_benchmarks=ON
make check-format

logger "Run C++ documentation generation..."
make docs
