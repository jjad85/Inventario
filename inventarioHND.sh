#! /bin/bash

####################################################################################
####                                                                            ####
#### Detalle:                                                                   ####
####    Shell que se encarga de realizar la administración de los productos     ####
####    de HND de la flaca, esta shell se encarga de realizar la creación de    ####
####    productos, adición de inventario y descargue de ventas.                 ####
####                                                                            ####
#### Autor:                                                                     ####
####    Juan José Arango Díaz                                                   ####
####                                                                            ####
#### Versiones:                                                                 ####
####    =====================================================================   ####
####    | # Versión |     Fecha     |             Detalle                   |   ####
####    =====================================================================   ####
####    |    1.0    |  17-07-2020   | Operaciones creadas:                  |   ####
####    |           |               |   * Validar inventario                |   ####
####    |           |               |   * Creación de producto              |   ####
####    |           |               |   * Agregar inventario                |   ####
####    |           |               |   * Disminuir Inventario              |   ####
####    =====================================================================   ####
####                                                                            ####
####################################################################################

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza el proceso de Login
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ValidarUsuario(){
	echo "		================================================"
	echo "			Sistema de inventario - Login"
	echo "		================================================"
	read -p "			Usuario: " strUsuario 
	read -p "			Contraseña:" strPass
	while IFS= read -r linea
	do
		indUsuarioVal=0
		user="$(cut -d ';' -f1 <<<"$linea")"
		pass="$(cut -d ';' -f2 <<<"$linea")"
		if [[ "$strUsuario" = "$user" && "$strPass" = "$pass" ]];
		then
			indUsuarioVal=1
		fi
	done < $Usuarios
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que presenta el menú principal
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
		echo "	=================================================================="
		echo "		Opciones de ejecución: "
		echo "			*******************************"
		echo "				CATEGORÍAS"
		echo "			*******************************"
		echo "				1. Crear Categorías"
		echo "				2. Editar Categorías"
		echo "				3. Eliminar Categorías"
		echo "				4. Consultar Categorías"
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
		echo "				ADMINISTRACIÓN"
		echo "			*******************************"
		echo "				0. Cerrar aplicación"
		echo " "
		echo "	=================================================================="
		read -p "		Ingrese opción: " pasoF	
		echo "	=================================================================="
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
	#sleep 1s
	paso=-1
	fun_MenuPrincipal $paso	
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que termina de forma controlada la ejecución del programa
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_TerminarEjecucion() {
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
	echo " Ejecución terminada. Hasta Pronto!"
	echo " Fecha fin proceso " $dia " " $hora
	echo "-------------------------------------------------------------------"
	exit 0
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la creación de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_CrearCategoria(){
	#============================================
	# Creación del archivo categorías
	#============================================
	if [ ! -f $Categorias ];
	then
		touch $Categorias
		chmod 775 $Categorias
	fi
	echo "	=================================================================="
	echo "		Una vez hayas finalizado de ingresar las "
	echo "		categorías escribe la palabra <<SALIR>>"
	echo "	=================================================================="
	nomCategoria=""
	while [[ "$nomCategoria" != "SALIR" ]]
	do
		echo "		-------------------------------"
		read -p "		Nombre: " nomCategoria
		nomCategoria=$(echo "$nomCategoria" | tr '[:lower:]' '[:upper:]')
		cantEspacios=$(echo ${#nomCategoria})
		if [ $cantEspacios -le $longNomCategoria ];
		then
			if [ "$nomCategoria" != "SALIR" ];
			then			
				indExisteCate=0
				fun_BuscarCategoria "$nomCategoria"
				if [ $indExisteCate = 0 ];
				then
					codCategoria=$(cat $Categorias | wc -l)
					codCategoria=$((codCategoria+1))
					#=================================
					# Construcción Categoria
					# codCat;nombre;activo
					#=================================
					strFinCategoria=$codCategoria";"$nomCategoria";1"
					echo $strFinCategoria>>$Categorias
				else
					echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
					echo "			La categoría ya se encuentra registrada"
					echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
				fi
			fi
		else
			echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
			echo "			La longitud máxima son $longNomCategoria caracteres"
			echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		fi
	done
	echo "		**************************************************"
	echo "			Categorías registradas con exito"
	echo "		**************************************************"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la edición de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EditarCategoria(){
	fun_SeleccionarCategoria
	if [ $swExiste = 1 ];
	then
		strNomViejo=$(cat $Categorias | sed -n $cat_Cod"p")
		strNomViejoUni=$(cut -d ';' -f2 <<<"$strNomViejo")
		echo " "
		echo "		------------------------------------------"
		echo "		Nombre anterior: "$strNomViejoUni
		read -p "		Nombre Nuevo: " strNomNuevo
		strNomNuevo=$(echo "$strNomNuevo" | tr '[:lower:]' '[:upper:]')
		strNomNuevo=$cat_Cod";"$strNomNuevo";1"
		echo$(sed -i 's/'$strNomViejo'/'$strNomNuevo'/g' $Categorias)
		echo " "
		echo "		**************************************************"
		echo "			Categoría editada con éxito"
		echo "		**************************************************"

	fi
	echo " "
	read -p "		Presiona la tecla ENTER para continuar... " a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la eliminación de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EliminarCategoria(){
	fun_SeleccionarCategoria
	if [ $swExiste = 1 ];
	then
		strNomViejo=$(cat $Categorias | sed -n $cat_Cod"p")
		indExisteProd=0
		fun_BuscarProductoCategoria "$cat_Cod"
		if [ $indExisteProd = 1 ];
		then 
			echo " "
			echo "			¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬"
			echo "			Existen productos asociados a la categoría seleccionada"
			echo "			¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬"
		fi 
		respuesta="Q"
		while [[ "$respuesta" != "S" && "$respuesta" != "N" ]]
		do
			read -p "		¿Desea eliminar la categoria [S|N]? " respuesta
			respuesta=$(echo "$respuesta" | tr '[:lower:]' '[:upper:]')
		done
		if [ "$respuesta" = "S" ];
		then
			nomCategoria="$(cut -d ';' -f2 <<<"$strNomViejo")"
			strNomNuevo=$cat_Cod";"$nomCategoria";0"
			echo $(sed -i 's/'$strNomViejo'/'$strNomNuevo'/g' $Categorias)
			echo "			**************************************************"
			echo "				Se elimina la categoría <<$nomCategoria>>"
			echo "			**************************************************"
		fi
	fi
	echo " "
	read -p "		Presiona la tecla ENTER para continuar... " a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la consulta de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ConsultarCategoria(){
	fun_ListarCategorias
	echo " "
	read -p "		Presiona la tecla ENTER para continuar... " a
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
	# Creación del archivo categorías
	#============================================
	if [ ! -f $Categorias ];
	then
		fun_CrearCategoria
	fi

	#============================================
	# Selección de la categoria
	#============================================
	echo " 	"
	echo "	=================================================================="
	echo "		PASO 1. Categorías disponibles"
	echo "	=================================================================="
	fun_SeleccionarCategoria

	#============================================
	# Selección del genero
	#============================================
	echo " 	"
	echo "	=================================================================="
	echo "		PASO 2. Selecciona el género"
	echo "	=================================================================="
	strGenero="Q"
	while [[ "$strGenero" != "H" && "$strGenero" != "M" && "$strGenero" != "U" ]]
	do
		if [ "$strGenero" != "Q" ];
		then
			echo "		-------------------------------------"
			echo "		Opción $strGenero NO es valida "
			echo "		-------------------------------------"
		fi
		echo "		(H) HOMBRE"
		echo "		(M) MUJER"
		echo "		(U) UNISEX"
		read -p "		Ingresa la letra del género: " strGenero
		strGenero=$(echo $strGenero | tr '[:lower:]' '[:upper:]')
	done
	
	#============================================
	# Datos basicos del producto
	#============================================
	echo " 	"
	echo "	=================================================================="
	echo "		PASO 3. Datos basicos del producto"
	echo "	=================================================================="
	#--------------------------------------------
	#	Código del producto
	#--------------------------------------------
	cantEspacios=$((longCodigo+5))
	while [[ $cantEspacios -gt $longCodigo ]]
	do
		read -p "		Código: " strCodigo
		if [  ! "$strCodigo"  ];
		then
			echo "		-------------------------------------"
			echo "		Debes ingresar un código"
			echo "		-------------------------------------"
		else
			cantEspacios=$(echo ${#strCodigo})
			if [ $cantEspacios -gt $longCodigo ];
			then
					echo "		-------------------------------------"
					echo "		La longitud máxima son $longCodigo caracteres"
					echo "		-------------------------------------"
			fi
		fi
	done

	#--------------------------------------------
	#	Nombre del producto
	#--------------------------------------------
	cantEspacios=$((longNomProducto+5))
	while [[ $cantEspacios -gt $longNomProducto ]]
	do
		read -p "		Nombre: " strNomProducto
		strNomProducto=$(echo $strNomProducto | tr '[:lower:]' '[:upper:]')
		if [  ! "$strNomProducto"  ];
		then
			echo "		-------------------------------------"
			echo "		Debes ingresar un nombre"
			echo "		-------------------------------------"
		else
			cantEspacios=$(echo ${#strNomProducto})
			if [ $cantEspacios -gt $longNomProducto ];
			then
					echo "		-------------------------------------"
					echo "		La longitud máxima son $longNomProducto caracteres"
					echo "		-------------------------------------"
			fi
		fi
	done

	#--------------------------------------------
	#	Valor de compra del producto
	#--------------------------------------------
	cantEspacios=$((longVlrCompra+5))
	while [[ $cantEspacios -gt $longVlrCompra || "$strValCompra" -lt "$valMinimo" ]]
	do
		read -p "		Valor Compra: " strValCompra
		if [[ ! "$strValCompra" || "$strValCompra" -lt "$valMinimo" ]];
		then 
			echo "		-------------------------------------"
			echo "		Debes ingresar un valor y >= a $valMinimo"
			echo "		-------------------------------------"	
		else
			cantEspacios=$(echo ${#strValCompra})
			if [ $cantEspacios -gt $longVlrCompra ];
			then
					echo "		-------------------------------------"
					echo "		La longitud máxima son $longVlrCompra caracteres"
					echo "		-------------------------------------"
			fi
		fi
	done

	#--------------------------------------------
	#	Valor de venta del producto
	#--------------------------------------------
	cantEspacios=$((longVlrVenta+5))
	while [[ $cantEspacios -gt $longVlrVenta || "$strValVenta" -lt "$strValCompra" ]]
	do
		read -p "		Valor Venta: " strValVenta
		if [[ ! "$strValVenta" || "$strValVenta" -lt "$strValCompra" ]];
		then 
			echo "		-------------------------------------"
			echo "		Debes ingresar un valor y >= a $strValCompra"
			echo "		-------------------------------------"
		else
			cantEspacios=$(echo ${#strValVenta})
			if [ $cantEspacios -gt $longVlrVenta ];
			then
					echo "		-------------------------------------"
					echo "		La longitud máxima son $longVlrVenta   caracteres"
					echo "		-------------------------------------"
			fi
		fi
	done
	
	#==================================================================
	# Construcción Producto
	# codPro;codCat;nombre;genero;cantidad;valCompra;valVenta;activo
	#==================================================================
	strFinProducto=$strCodigo";"$strCodCategoria";"$strNomProducto";"$strGenero";0;"$strValCompra";"$strValVenta";1"
	indExisteProd=0
	fun_BuscarProductoCodigo "$strCodigo"
	if [ $indExisteProd = 0 ];
	then
		echo $strFinProducto>>$Productos
		echo "		**************************************************"
		echo "			Producto registrado con éxito"
		echo "		**************************************************"
	else
		echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		echo "			El producto ya se encuentra registrado"
		echo "		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
	fi
	unset strCodCategoria
	unset strNomProducto
	unset strValCompra
	unset strValVenta
	unset strCodigo
	unset strGenero
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la edición de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EditarProducto(){
	fun_SeleccionarProducto
	if [ $swExiste = 1 ];
	then
		strNewCategoria=$prd_codCat
		strNewNombre=$prd_codCat
		strNewGenero=$prd_genero
		strNewVlrCompra=$prd_genero
		strNewVlrVenta=$prd_valVenta
		
		echo " "
		echo "		------------------------------------------"
		echo "				Categoría"
		echo "		------------------------------------------"
		while [[ "$RespCategoria" != "S" && "$RespCategoria" != "N" ]]
		do
			read -p "		¿Dese editar la categoría? [S|N] " RespCategoria
			RespCategoria=$(echo "$RespCategoria" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespCategoria = "S" ];
		then 
			echo "		Actual: "$prd_nomCat
			fun_SeleccionarCategoria
			strNewCategoria=$strOrden
		fi
		
		echo " "
		echo "		------------------------------------------"
		echo "				Nombre"
		echo "		------------------------------------------"
		while [[ "$RespNombre" != "S" && "$RespNombre" != "N" ]]
		do
			read -p "		¿Dese editar el nombre? [S|N] " RespNombre
			RespNombre=$(echo "$RespNombre" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespNombre = "S" ];
		then 
			echo "		Actual: "$prd_nombre
			
			cantEspacios=$((longNomProducto+5))
			while [[ $cantEspacios -gt $longNomProducto ]]
			do
				read -p "		Nuevo: " strNewNombre
				strNewNombre=$(echo $strNewNombre | tr '[:lower:]' '[:upper:]')
				if [  ! "$strNewNombre"  ];
				then
					echo "		-------------------------------------"
					echo "		Debes ingresar un nombre"
					echo "		-------------------------------------"
				else
					cantEspacios=$(echo ${#strNewNombre})
					if [ $cantEspacios -gt $longNomProducto ];
					then
							echo "		-------------------------------------"
							echo "		La longitud máxima son $longNomProducto caracteres"
							echo "		-------------------------------------"
					fi
				fi
			done
		fi

		echo " "
		echo "		------------------------------------------"
		echo "				Género"
		echo "		------------------------------------------"
		while [[ "$RespGenero" != "S" && "$RespGenero" != "N" ]]
		do
			read -p "		¿Dese editar el género? [S|N] " RespGenero
			RespGenero=$(echo "$RespGenero" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespGenero = "S" ];
		then 
			echo "		Actual: "$prd_genero
			strNewGenero="Q"
			while [[ "$strNewGenero" != "H" && "$strNewGenero" != "M" && "$strNewGenero" != "U" ]]
			do
				if [ "$strNewGenero" != "Q" ];
				then
					echo "		-------------------------------------"
					echo "		Opción $strNewGenero NO es valida "
					echo "		-------------------------------------"
				fi
				echo "		(H) HOMBRE"
				echo "		(M) MUJER"
				echo "		(U) UNISEX"
				read -p "		Ingresa la letra del género: " strNewGenero
				strNewGenero=$(echo $strNewGenero | tr '[:lower:]' '[:upper:]')
			done
		fi

		echo " "
		echo "		------------------------------------------"
		echo "				Valor Compra"
		echo "		------------------------------------------"
		while [[ "$RespVlrCompra" != "S" && "$RespVlrCompra" != "N" ]]
		do
			read -p "		¿Dese editar el valor de compra? [S|N] " RespVlrCompra
			RespVlrCompra=$(echo "$RespVlrCompra" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespVlrCompra = "S" ];
		then 
			echo "		Actual: "$prd_valCompra
			cantEspacios=$((longVlrCompra+5))
			while [[ $cantEspacios -gt $longVlrCompra || "$strNewVlrCompra" -lt "$valMinimo" ]]
			do
				read -p "		Valor Compra: " strNewVlrCompra
				if [[ ! "$strNewVlrCompra" || "$strNewVlrCompra" -lt "$valMinimo" ]];
				then 
					echo "		-------------------------------------"
					echo "		Debes ingresar un valor y >= a $valMinimo"
					echo "		-------------------------------------"	
				else
					cantEspacios=$(echo ${#strNewVlrCompra})
					if [ $cantEspacios -gt $longVlrCompra ];
					then
							echo "		-------------------------------------"
							echo "		La longitud máxima son $longVlrCompra caracteres"
							echo "		-------------------------------------"
					fi
				fi
			done
		else
			strNewVlrCompra=$prd_valCompra
		fi

		echo " "
		echo "		------------------------------------------"
		echo "				Valor Venta"
		echo "		------------------------------------------"
		while [[ "$RespVlrVenta" != "S" && "$RespVlrVenta" != "N" ]]
		do
			read -p "		¿Dese editar el valor de venta? [S|N] " RespVlrVenta
			RespVlrVenta=$(echo "$RespVlrVenta" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespVlrVenta = "S" ];
		then
			echo "		Actual: "$prd_valVenta
			cantEspacios=$((longVlrVenta+5))
			while [[ $cantEspacios -gt $longVlrVenta || "$strNewVlrVenta" -lt "$strNewVlrCompra" ]]
			do
				read -p "		Valor Venta: " strNewVlrVenta
				if [[ ! "$strNewVlrVenta" || "$strNewVlrVenta" -lt "$strNewVlrCompra" ]];
				then 
					echo "		-------------------------------------"
					echo "		Debes ingresar un valor y >= a $strNewVlrCompra"
					echo "		-------------------------------------"
				else
					cantEspacios=$(echo ${#strNewVlrVenta})
					if [ $cantEspacios -gt $longVlrVenta ];
					then
							echo "		-------------------------------------"
							echo "		La longitud máxima son $longVlrVenta   caracteres"
							echo "		-------------------------------------"
					fi
				fi
			done
		fi

		strProdActual=$strProducto
		strProdNuevo=$prd_Cod";"$strNewCategoria";"$strNewNombre";"$strNewGenero";"$prd_cantidad";"$strNewVlrCompra";"$strNewVlrVenta";1"
		echo "Actual: "$strProdActual
		echo "Nuevo: "$strProdNuevo
		echo $(sed -i s/$strProdActual/$strProdNuevo/g $Productos)
		echo " "
		echo "		**************************************************"
		echo "			Producto editado con éxito"
		echo "		**************************************************"
		unset RespCategoria
		unset RespNombre
		unset RespGenero
		unset RespVlrCompra
		unset RespVlrVenta
	fi
	echo " "
	read -p "		Presiona la tecla ENTER para continuar... " a
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
	fun_ListarProductos
	echo " "
	read -p "		Presiona la tecla ENTER para continuar... " a
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

#=================================================================================
#=================================================================================
# 	Funciones administrativas y de apoyo
#=================================================================================
#=================================================================================

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que busca un producto por codigo
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_BuscarProductoCodigo() {
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
#	Función que busca un producto por categoría
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_BuscarProductoCategoria() {
	strCategoria=$1

	while IFS= read -r linea
	do
		numCodigo="$(cut -d ';' -f2 <<<"$linea")"
		if [ "$strCategoria" = "$numCodigo" ];
		then
			indExisteProd=1
		fi
	done < $Productos
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que busca una categoría por nombre
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_BuscarCategoria(){
	strCategoria=$1

	while IFS= read -r linea
	do
		cate="$(cut -d ';' -f2 <<<"$linea")"
		if [ "$strCategoria" = "$cate" ];
		then
			indExisteCate=1
		fi
	done < $Categorias
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que selecciona la categoria deseada
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_SeleccionarCategoria(){
	strOrden=-1
	swCiclo=1
	while [[ "$swCiclo" != "0" ]]
	do
		if [ "$strOrden" != "-1" ];
		then
			echo "		-------------------------------------"
			echo "		Opción $strOrden NO es valida "
			echo "		-------------------------------------"
		fi
		orden=1
		fun_ListarCategorias
		if [ $swExiste = 1 ];
		then
			read -p "		Ingresa el el número de la categoría que desea: " strOrden		
			if [[ "$strOrden" -ge "1" && "$strOrden" -le "$orden" ]];
			then			
				strCategoria=$(cat $Categorias | sed -n $strOrden"p")			
				cat_Cod="$(cut -d ';' -f1 <<<"$strCategoria")"
				cat_nombre="$(cut -d ';' -f2 <<<"$strCategoria")"
				swCiclo=0
			fi
		fi
	done
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que Lista todas las categorías y retorna el codigo de la
#	categoría seleccionada
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ListarCategorias(){
	echo " 	"
	echo "	=================================================================="
	echo "		Categorías Existentes"
	echo "	=================================================================="
	echo " "
	echo "		~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "		|  CÓDIGO  |   CATEGORÍA   |"
	echo "		~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	swExiste=0
	if [ -f $Categorias ];
	then
		while IFS= read -r lineaCt
		do
			swExiste=1
			cat_activo="$(cut -d ';' -f3 <<<"$lineaCt")"
			if [ "$cat_activo" = "1" ];
			then
				orden=$((orden+1))
				impCategorias=""
				cat_Cod="$(cut -d ';' -f1 <<<"$lineaCt")"
				cantEspacios=$(echo ${#cat_Cod})
				cantEspacios=$((longCodigo-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impCategorias=$impCategorias$(echo "|"$cat_Cod$strEspacios"|")

				cat_nombre="$(cut -d ';' -f2 <<<"$lineaCt")"
				cantEspacios=$(echo ${#cat_nombre})
				cantEspacios=$((longNomCategoria-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impCategorias=$impCategorias$(echo $cat_nombre$strEspacios"|")

				echo "		"$impCategorias	
			fi
		done < $Categorias
	fi
	if [ $swExiste = 0 ];
	then
		echo "		|     NO HAY CATEGORÍAS    |"
		swCiclo=0
	fi
	echo "		~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que selecciona el producto deseado
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_SeleccionarProducto(){
	strOrden=-1
	swCiclo=1
	while [[ "$swCiclo" != "0" ]]
	do

		if [ "$strOrden" != "-1" ];
		then
			echo "		-------------------------------------"
			echo "		Opción $strOrden NO es valida "
			echo "		-------------------------------------"
		fi
		orden=1
		fun_ListarProductos
		if [ $swExiste = 1 ];
		then
			read -p "		Ingresa el el numero del producto que desea: " strOrden
			if [[ "$strOrden" -ge "1" && "$strOrden" -le "$orden" ]];
			then
				strProducto=$(cat $Productos | sed -n $strOrden"p")			
				prd_Cod="$(cut -d ';' -f1 <<<"$strProducto")"
				prd_codCat="$(cut -d ';' -f2 <<<"$strProducto")"
				prd_codCat=$prd_codCat
				prd_nomCat=$(cat $Categorias | sed -n $prd_codCat"p")
				prd_nomCat="$(cut -d ';' -f2 <<<"$prd_nomCat")"
				prd_nombre="$(cut -d ';' -f3 <<<"$strProducto")"
				prd_genero="$(cut -d ';' -f4 <<<"$strProducto")"
				prd_cantidad="$(cut -d ';' -f5 <<<"$strProducto")"
				prd_valCompra="$(cut -d ';' -f6 <<<"$strProducto")"
				prd_valVenta="$(cut -d ';' -f7 <<<"$strProducto")"
				swCiclo=0
			fi
		else
			swCiclo=0
		fi	
	done
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que lista todos los productos de una categoría y retorna 
#	el codigo del producto seleccionado
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ListarProductos(){
	echo " 	"
	echo "	=================================================================="
	echo "		Productos Existentes"
	echo "	=================================================================="
	echo " "
	echo "		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "		| ORD |  CÓDIGO  |   CATEGORÍA   |          NOMBRE         | GÉNERO | CANTIDAD | VLR COMPR | VLR VENTA |"
	echo "		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	swExiste=0
	orden=1
	if [ -f $Productos ];
	then 
		while IFS= read -r lineaCt
		do
			swExiste=1
			prd_activo="$(cut -d ';' -f8 <<<"$lineaCt")"
			if [ "$prd_activo" = "1" ];
			then

				#---------------------------------------
				# Impresión del orden
				#---------------------------------------
				impProducto=""
				cantEspacios=$(echo ${#orden})
				cantEspacios=$((5-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo "|"$orden$strEspacios"|")
				orden=$((orden+1))

				#---------------------------------------
				# Impresión del código
				#---------------------------------------				
				prd_Cod="$(cut -d ';' -f1 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_Cod})
				cantEspacios=$((longCodigo-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_Cod$strEspacios"|")

				#---------------------------------------
				# Impresión de la categoría
				#---------------------------------------
				prd_codCat="$(cut -d ';' -f2 <<<"$lineaCt")"
				prd_nomCat=$(cat $Categorias | sed -n $prd_codCat"p")
				prd_nomCat="$(cut -d ';' -f2 <<<"$prd_nomCat")"
				cantEspacios=$(echo ${#prd_nomCat})
				cantEspacios=$((longNomCategoria-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_nomCat$strEspacios"|")

				#---------------------------------------
				# Impresión del nombre
				#---------------------------------------
				prd_nombre="$(cut -d ';' -f3 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_nombre})
				cantEspacios=$((longNomProducto-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_nombre$strEspacios"|")

				#---------------------------------------
				# Impresión del genero
				#---------------------------------------
				prd_genero="$(cut -d ';' -f4 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_genero})
				cantEspacios=$((longGenero-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_genero$strEspacios"|")

				#---------------------------------------
				# Impresión de la cantidad
				#---------------------------------------
				prd_cantidad="$(cut -d ';' -f5 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_cantidad})
				cantEspacios=$((longCantidad-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_cantidad$strEspacios"|")

				#---------------------------------------
				# Impresión del valor compra
				#---------------------------------------
				prd_valCompra="$(cut -d ';' -f6 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_valCompra})
				cantEspacios=$((longVlrCompra-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_valCompra$strEspacios"|")

				#---------------------------------------
				# Impresión del valor compra
				#---------------------------------------
				prd_valVenta="$(cut -d ';' -f7 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_valVenta})
				cantEspacios=$((longVlrCompra-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo $prd_valVenta$strEspacios"|")

				echo "		"$impProducto	
			fi
		done < $Productos
	fi
	if [ $swExiste = 0 ];
	then
		echo "		|                                   NO HAY PRODUCTOS QUE MOSTRAR                                       |"
		swCiclo=0
	fi
	echo "		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
# Función que copmplementa de espacios un texto para presentar en 
# pantalla, segun la longitud definida. 
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
funEspacios(){
	cantEspacios=$1
	for (( i=1; i<=$cantEspacios; i++ ))
	do 
		strEspacios=$(echo -e $strEspacios"·")
	done
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
indUsuarioVal=-1
indExisteCate=0
strNomCategoria=0
strCodCategoria=0
longCodigo=10
longNomCategoria=15
longNomProducto=25
longGenero=8
longCantidad=10
longVlrCompra=11
longVlrVenta=11
categ=""
prd_Cod=""
prd_codCat=""
prd_nomCat=""
prd_nombre=""
prd_genero=""
prd_cantidad=""
prd_valCompra=""
prd_valVenta=""
prd_activo=""
cat_Cod=""
cat_nombre=""
cat_activo=""
strEspacios=""
swExiste=0

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

while [[ $indUsuarioVal = 0 || $indUsuarioVal = -1 ]]
do
	fun_ValidarUsuario
	if [ $indUsuarioVal = 1 ];
	then
		#-----------------------------------------------------------
		#Inicio de ejecución
		#-----------------------------------------------------------
		paso=-1
		fun_MenuPrincipal $paso
	elif [ $indUsuarioVal = 0 ];
	then
		echo "			{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		echo "			Usuario/Contraseña incorrecta"
		echo "			{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
	fi
done
