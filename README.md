# Dubins Coverage for the Traveling Salesman

## MATLAB

To run the matlab simulations you must first builds the necessary mex files.

### Compiling Dubins Curve Mex
To compile Dubins Curve Mex by changing into the `lib/DubinsPlot` directory,
and running:

    mex src/dubins.cpp

This will create a dubins.mex<postfix> file, eg. dubins.mexw64 on Windows 7
64-bit, which is used for plot continuous Dubins vehicle trajcetories in figures.
