#! /bin/bash

####################################################################################
####																			####
#### Detalle:																	####
#### 	Shell que se encarga de realizar la administración de los productos 	####
#### 	de HND de la flaca, esta shell se encarga de realizar la creación de	####
#### 	productos, adición de inventario y descargue de ventas.					####
####																			####
#### Autor:																		####
####	Juan José Arango Diaz													####
####																			####
#### Versiones:																	####
####	=====================================================================	####
####	| # Versión	|		Fecha	|				Detalle					|	####
####	=====================================================================	####
####	|	1.0		|	17-07-2020	| Operaciones creadas:					|	####
####	|			|				|	* Validar inventario 				|	####
####	|			|				|	* Creación de producto 				|	####
####	|			|				|	* Agregar inventario 				|	####
####	|			|				|	* Disminuir Inventario 				|	####
####	=====================================================================	####
####																			####
####################################################################################

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza el proceso de Login
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ValidarUsuario(){
	echo "	############################################################"
	echo "	############################################################"
	echo "	######      ## ############ ########      ####### ##########"
	echo "	###### ####### ########## ### ##### ########### ### ########"
	echo "	######      ## ########## ### ##### ########### ### ########"
	echo "	###### ####### ########         ### #########         ######"
	echo "	###### ####### ######## ####### ### ######### ####### ######"
	echo "	###### #######      ## ######### ###      ## ######### #####"
	echo "	############################################################"
	echo "	############################################################"
	echo "	"
	echo "		================================================"
	echo "			Sistema de inventario - Login"
	echo "		================================================"
	echo -n "			Usuario:"
	read strUsuario
	echo -n "			Contraseña:"
	read strPass
	while IFS= read -r linea
	do
		user="$(cut -d ';' -f1 <<<"$linea")"
		pass="$(cut -d ';' -f2 <<<"$linea")"
		if [[ "$strUsuario" = "$user" && "$strPass" = "$pass" ]];
		then
			indUsuarioVal=1
		fi
	done < $Usuarios
}


#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que presenta el menu princial
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_MenuPrincipal() {
	pasoF=$1
	while [[ "$pasoF" -lt "0" ||" $pasoF" -gt "10" ]]
	do	
		echo " "
		#-----------------------------------------------------------
		#Validación de opción no valida
		#-----------------------------------------------------------
		if [ "$pasoF" != "-1" ];
		then
			echo "	-------------------------------------"
			echo "	Opción $pasoF NO es valida "
			echo "	-------------------------------------"
		fi
		
		#-----------------------------------------------------------
		#Impresión de funciones
		#---------------------------------------------------------
		echo " 	============================================================="
		echo "		Opciones de ejecución: "
		echo "			*******************************"
		echo "				CATEGORIAS"
		echo "			*******************************"
		echo "				1. Crear Categorias"
		echo "				2. Editar Categorias"
		echo "				3. Eliminar Categorias"
		echo "				4. Consltar Categorias"
		echo "			*******************************"
		echo "				PRODUCTOS"
		echo "			*******************************"
		echo "				5. Crear Productos"
		echo "				6. Editar Productos"
		echo "				7. Eliminar Productos"
		echo "				8. Consultar Productos"
		echo "			*******************************"
		echo "				INVENTARIO"
		echo "			*******************************"
		echo "				9. Agregar inventario"
		echo "				10. Disminuir inventario"
		echo "			*******************************"
		echo "				ADMINISTRACION"
		echo "			*******************************"
		echo "				0. Cerrar aplicacion"
		echo " "
		echo " 	============================================================="
		read -p "		Ingrese opción: " pasoF	
		echo " 	============================================================="
		echo " "
	done
	paso=$pasoF
	case $paso in 
		0) fun_TerminarEjecucion ;;
		1) fun_CrearCategoria ;;
		2) fun_EditarCategoria ;;
		3) fun_EliminarCategoria ;;
		4) fun_ConsultarCategoria ;;
		5) fun_CrearProducto ;;
		6) fun_EditarProducto ;;
		7) fun_EliminarProducto ;;
		8) fun_ConsultarProducto ;;
		9) fun_AgregarInventario ;;
		10) fun_DisminuirInventario ;;
	esac
	sleep 1s
	paso=-1
	fun_MenuPrincipal $paso	
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que termina de forma controlada la ejecución del programa
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_TerminarEjecucion(){
		#-----------------------------------------------------------
	#Definición de fecha del proceso
	#-----------------------------------------------------------
	dia=`date +"%Y%m%d"`
	hora=`date +"%H:%M"`

	#-----------------------------------------------------------
	#Impresión del inicio de la shell
	#-----------------------------------------------------------	
	echo " "
	echo "-------------------------------------------------------------------"
	echo " Shell finalizada con exito. Hasta Pronto!"
	echo " Fecha fin proceso " $dia " " $hora
	echo "-------------------------------------------------------------------"
	exit 0
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la creación de las categorias
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_CrearCategoria(){
	echo "fun_CrearCategoria"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la edición de las categorias
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EditarCategoria(){
	echo "fun_EditarCategoria"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la eliminación de las categorias
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EliminarCategoria(){
	echo "fun_EliminarCategoria"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la consulta de las categorias
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ConsultarCategoria(){
	echo "fun_ConsultarCategoria"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la creación de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_CrearProducto(){
	#============================================
	# Creación del archivo de productos
	#============================================
	if [ ! -f $Productos ];
	then
		touch $Productos
		chmod 775 $Productos
	fi

	#============================================
	# Creación del archivo categorias
	#============================================
	if [ ! -f $Categorias ];
	then
		touch $Categorias
		chmod 775 $Categorias
		echo "	=================================================================="
		echo " 		A continuación deberas ingresar las categorias"
		echo "		que necesites para administrar tus productos."
		echo "		Una vez hayas finalizado de ingresar las "
		echo "		categorias escribe la palabra <<SALIR>>"
		echo "	=================================================================="
		nomCategoria="a"
		while [[ "$nomCategoria" != "SALIR" ]]
		do
			read -p "		Ingrese el nombre de la categoria: " nomCategoria
			nomCategoria=$(echo "$nomCategoria" | tr '[:lower:]' '[:upper:]')
			if [ "$nomCategoria" != "SALIR" ];
			then 
				echo $nomCategoria>>$Categorias
			fi
		done
	fi

	#============================================
	# Selección de la categoria
	#============================================
	echo " 	"
	echo "	=================================================================="
	echo "		PASO 1. Categorias disponibles"
	echo "	=================================================================="
	numCategoria=-1
	numCat=1
	numMaxCat=$(cat $Categorias | wc -l)
	while [[ "$numCategoria" -lt "1" ||" $numCategoria" -gt "$numMaxCat" ]]
	do
		if [ "$numCategoria" != "-1" ];
		then
			echo "		-------------------------------------"
			echo "		Opción $numCategoria NO es valida "
			echo "		-------------------------------------"
			numCat=1
		fi

		while IFS= read -r lineaCt
		do
			echo "		"$numCat". "$lineaCt
			numCat=$((numCat+1))
		done < $Categorias
		read -p "		Ingresa el numero de la categoria: " numCategoria
	done
	numCategoria=$numCategoria"p"
	strCategoria=$(cat $Categorias | sed -n $numCategoria)

	#============================================
	# Selección del genero
	#============================================
	echo " 	"
	echo "	=================================================================="
	echo "		PASO 2. Selecciona el genero"
	echo "	=================================================================="
	numGenero=-1
	while [[ "$numGenero" -lt "1" ||" $numGenero" -gt "3" ]]
	do
		if [ "$numGenero" != "-1" ];
		then
			echo "		-------------------------------------"
			echo "		Opción $numGenero NO es valida "
			echo "		-------------------------------------"
		fi
		echo "		1. HOMBRE"
		echo "		2. MUJER"
		echo "		3. UNISEX"
		read -p "		Ingresa el numero del genero: " numGenero
	done
	
	#============================================
	# Datos basicos del producto
	#============================================
	echo " 	"
	echo "	=================================================================="
	echo "		PASO 3. Datos basicos del producto"
	echo "	=================================================================="
	while [[ ! "$strCodigo" ]]
	do
		read -p "		CODIGO: " strCodigo
		if [  ! "$strCodigo"  ];
		then
			echo "		-------------------------------------"
			echo "		Debes ingresar un codigo"
			echo "		-------------------------------------"
		fi
	done
	while [[ ! "$strNomProducto" ]]
	do
		read -p "		NOMBRE: " strNomProducto
		if [  ! "$strNomProducto"  ];
		then
			echo "		-------------------------------------"
			echo "		Debes ingresar un nombre"
			echo "		-------------------------------------"
		fi
	done
	strNomProducto=$(echo $strNomProducto | tr '[:lower:]' '[:upper:]')
	while [[ ! "$strValCompra" || "$strValCompra" -lt "$valMinimo" ]]
	do
		read -p "		VALOR COMPRA: " strValCompra
		if [[ ! "$strValCompra" || "$strValCompra" -lt "$valMinimo" ]];
		then 
			echo "		-------------------------------------"
			echo "		Debes ingresar un valor y >= a $valMinimo"
			echo "		-------------------------------------"	
		fi
	done
	while [[ ! "$strValVenta" || "$strValVenta" -lt "$strValCompra" ]]
	do
		read -p "		VALOR VENTA: " strValVenta
		if [[ ! "$strValVenta" || "$strValVenta" -lt "$strValCompra" ]];
		then 
			echo "		-------------------------------------"
			echo "		Debes ingresar un valor y >= a $strValCompra"
			echo "		-------------------------------------"	
		fi
	done
	
	#============================================
	# Construcción Producto
	# categoria;nombre;0;valCompra;valVenta
	#============================================
	strFinProducto=$strCodigo";"$strCategoria";"$strNomProducto";0;"$strValCompra";"$strValVenta
	indExisteProd=0
	fun_BuscarProductoCatNom "$strCodigo"
	if [ $indExisteProd != 1 ];
	then
		echo $strFinProducto>>$Productos
		echo "		**************************************************"
		echo "			Producto registrado con exito"
		echo "		**************************************************"
	else
		echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		echo "			El producto ya se encuentra registrado"
		echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
	fi
	unset strCategoria
	unset strNomProducto
	unset strValCompra
	unset strValVenta
	unset strCodigo
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la edición de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EditarProducto(){
	echo "fun_EditarProducto"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la eliminación de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EliminarProducto(){
	echo "fun_EliminarProducto"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la consulta de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ConsultarProducto(){
	echo "fun_ConsultarProducto"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	FFunción que aumenta el inventario de un producto
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_AgregarInventario(){
	echo "fun_AgregarInventario"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	FFunción que disminuye el inventario de un producto
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_DisminuirInventario(){
	echo "fun_DisminuirInventario"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que busca un producto por categoria y nombre
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_BuscarProductoCatNom() {
	strCodigo=$1

	while IFS= read -r linea
	do
		codigo="$(cut -d ';' -f1 <<<"$linea")"
		if [ "$strCodigo" = "$codigo" ];
		then
			indExisteProd=1
		fi
	done < $Productos
}


#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
# Metodo MAIN
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

#-----------------------------------------------------------
#Definición de fecha del proceso
#-----------------------------------------------------------
dia=`date +"%Y%m%d"`
hora=`date +"%H:%M"`

#-----------------------------------------------------------
#Definición de variables necesarias
#-----------------------------------------------------------
Log="LogProceso.log"
Productos="Productos.txt"
Categorias="Categorias.txt"
Usuarios="Usuarios.txt"
valMinimo=10000
indExisteProd=0
indUsuarioVal=0

fun_ValidarUsuario
if [ $indUsuarioVal = 1 ];
then
	#-----------------------------------------------------------
	#Inicio de ejecución
	#-----------------------------------------------------------

	paso=-1
	fun_MenuPrincipal $paso
else
	echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
	echo "			Usuario/Contraseña incorrecta"
	echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
fi
