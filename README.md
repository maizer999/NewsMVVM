[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
# Native News app for iOS with Swift

A sample iOS application displays a news feed from New York Times  with an MVVM design patern


## How to use this repository

1. Download and Install last Xcode version 
 
2. Open Terminal.
     
4. Change the current working directory to the location where you want the cloned directory.
 
5. $ git clone https://github.com/maizer999/NewsMVVM.git
          
6. Press Enter to create your local clone.

7. After finish just make sure to install pod file using $ pod install

Note: we didn't add git ignore to the repo since the project size is small and to make it easy to user to check the code



## About code structure 

View Model has responsibility to update View as well as get updates from View regarding the changes made by the user. 
This can be achieved by minimum code using bi-directional data binding. 
But … iOS has no two way binding mechanism available out of the box


## Unit tests

We add number of test cases to check the response 

1. to check the number of result you can use "testHttpFetch" test case 

2. to check the response status you can use "runAsynchCode"  test case 



## Keywords

Simple News App , MVVM , Swift , Alamofire , 
