----Manual for BNCT cell generator program and mcedit code editor for PHITS Monte Carlo package----
====================================================================================
```
**Brief intro**
The cell generator program was written in FORTRAN90 programming language. The mcedit code editor program was written in C programming language. 
```
```
**Requirements to run**
```
```
1.	You need terminal, if you are using GNU/Linux you are good. If you are using MacOS then you have terminal built-in the OS. 
If you are using Windows, you can use Cygwin terminal. 
```
```
2.	You need GCC package (gfortran and gcc compiler).
```
```
3.	For gnuplot visualization, you need gnuplot package.
```
```
**How to use?** 
```
```
1.	Go to the code directory and makeù.
```
```
2.	To run cell generator program run make gen.ù
```
```
3.	Choose what operational mode you like, reading from 
input.dat type (1), if you prefer keyboard input type (2).
```
```
4.	The code file will be generated as ‚Äúxxxxx_code.inp‚Äù, where xxxxx is a number of each input code.
```
```
5.	Ton run mcedit to view the latest input code run make editù.
```
```
**Bug report**
If you have encountered any bugs or issues, please report it to: ben.sh@my.cityu.edu.hk 
```
```
**Developers**
The programs were developed by Mehrdad S. Beni, Hiroshi Watabe and Peter K.N. Yu. 
```