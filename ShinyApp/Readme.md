This Shiny application trains a machine learning algorithm to predict the monthly rent for apartments in Bogota, Colombia. The algorithm is trained using online clasified ads published in the local news paper [web page](http://clasificados.eltiempo.com/avisos/vivienda/arriendo-apartamentos-chapinero). 

The data was collected on September 23/2015 using `rvest` package developed by Hadley Wickham and contains 1000 records of the last published ads. Data can be downloaded from this [link](https://www.dropbox.com/s/da3iy8xo1agfojd/tidy.csv?dl=0).

The machine learning algorithm was trained using all the complete cases of the data. The data was wrangled and the final data set contains the following variables: `logarea`,`logarea^2`,`neighbourhood`,`bathrooms`,`rooms`,`area/rooms ratio`, and `bathrooms/rooms ratio`. Several algorithms were tuned and tested using this variables, and random forest shows the best performance using 10-fold cross-validation (with an Rsquared of 0.76).

Contact info:

+ Twitter: [@\_mabolivar](https://twitter.com/\_mabolivar)
+ Github: [https://github.com/mabolivar](https://github.com/mabolivar)
+ LinkedIn: [Manuel A. Bolivar](http://bit.ly/1jlsIcL)
