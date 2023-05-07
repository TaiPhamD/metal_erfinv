pushd .
# if build exist delete it
if [ -d "build" ]; then
  rm -rf build
fi
mkdir build
cd build
cmake ..
make
popd

python test.py