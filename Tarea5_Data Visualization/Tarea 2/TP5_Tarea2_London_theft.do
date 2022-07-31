********************************************************************************************
/* 					Herramientas Computacionales de Investigacion
							Trabajo Practico 5
					  Gonzalo Rigirozzi y Luis Cerda   						  */
********************************************************************************************

********************************************************************************************
/* 					  INSTALACIÓN DE LOS PAQUETES NECESARIOS    						  */
********************************************************************************************

ssc install spmap
ssc install shp2dta
*net install sg162, from(http://www.stata.com/stb/stb60)
*net install st0292, from(http://www.stata-journal.com/software/sj13-2)
net install spwmatrix, from(http://fmwww.bc.edu/RePEc/bocode/s)
*net install splagvar, from(http://fmwww.bc.edu/RePEc/bocode/s)
*ssc install xsmle.pkg
*ssc install xtcsd
*net install st0446.pkg


* Se setea el directorio con el se va a trabajar.
cd "/Users/gonzalorigirozzi/Desktop/Clase 5/videos 2 y 3/data"

* Se selecciona la data con que se va a trabajar.
use london_crime_shp.dta, clear

* Se mantiene unicamente x_c y y_c  y se los guarda.
keep x_c y_c name
save "labels.dta", replace


* Se selecciona la base.
use london_crime_shp.dta, clear


* Se utiliza el paquete spmap para armar el mapa 2
spmap crimecount using coord_ls, id(id) line(data("coord_ls.dta") color(gs20) size(vthin))clmethod(e) cln(4)label(data("labels.dta") x(x_c) y(y_c) label(name) size(vsmall))   legend(size(vsmall) position(5) xoffset(1)) legtitle("Amount of Thefts by borough") fcolor(Blues2) plotregion(margin(large)) ndfcolor(gray)      

