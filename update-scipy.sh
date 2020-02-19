#!/bin/bash

# Remove old numpy et al
sudo apt remove python3-numpy
sudo apt autoremove -y

# Install up to date versions
sudo pip install --upgrade pip
sudo apt install -y libopenblas-dev 
sudo apt install -y libatlas-base-dev
sudo pip install numpy pybind11

# Scipy takes forever to build...
# time == 105+ minutes (or 42 minutes on my 2GB RAM Pi4B)
# sudo pip install scipy 

# time == 50 seconds
# wget https://github.com/EE123-students/lab2-template/raw/master/scipy-1.4.1-cp35-cp35m-linux_armv7l.whl
sudo pip install ./scipy*.whl
sudo pip install matplotlib pyparsing pillow tz
sudo pip install --upgrade pyrtlsdr 

# Benchmark the new convolve
setup="import scipy.signal as signal; import numpy as np; x = np.random.randn(2**15); w = signal.hann(512); "
testoa="y = signal.oaconvolve(x,w)"
testfft="y = signal.convolve(x,w,method='fft')"
testtd="y = signal.convolve(x,w,method='direct')"

echo "Overlap-Add convolution..."
python3 -m timeit -n 25 -s "$setup" "$testoa"
echo "FFT convolution..."
python3 -m timeit -n 25 -s "$setup" "$testfft"
echo "Direct convolution..."
python3 -m timeit -n 25 -s "$setup" "$testtd"

