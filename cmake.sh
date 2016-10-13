source template/archer_setup.sh

cp CMakeLists.txt ../AxiSEM3D/SOLVER/CMakeLists.txt

rm -rf build
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE ../../AxiSEM3D/SOLVER
make -j16
cp axisem3d ../template/
cd .. 