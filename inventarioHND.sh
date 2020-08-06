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
	echo -e "\e[34m		================================================"
	echo -e "\e[39m			Sistema de inventario - Login"
	echo -e "\e[34m		================================================\e[39m"
	read -p $'			\e[92mUsuario:\e[39m ' strUsuario 
	read -p $'			\e[92mContraseña:\e[39m ' strPass
	while IFS= read -r linea
	do
		indUsuarioVal=0
		user="$(cut -d ';' -f1 <<<"$linea")"
		pass="$(cut -d ';' -f2 <<<"$linea")"
		if [[ "$strUsuario" = "$user" && "$strPass" = "$pass" ]];
		then
			indUsuarioVal=1
		fi
	done < $txtUsuarios
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
			echo -e "\e[91m	-------------------------------------"
			echo -e "\e[91m	Opción $pasoF NO es valida "
			echo -e "\e[91m	-------------------------------------\e[39m"
		fi
		
		#-----------------------------------------------------------
		#Impresión de funciones
		#---------------------------------------------------------
		echo -e "\e[34m	============================================================"
		echo -e "\e[39m"
		echo -e "\e[34m		*******************************"
		echo -e "\e[39m			CATEGORÍAS"
		echo -e "\e[34m		*******************************"
		echo -e "\e[92m		1. \e[39mCrear Categorías"
		echo -e "\e[92m		2. \e[39mEditar Categorías"
		echo -e "\e[92m		3. \e[39mEliminar Categorías"
		echo -e "\e[92m		4. \e[39mConsultar Categorías"
		echo -e "\e[34m		*******************************"
		echo -e "\e[39m			PRODUCTOS"
		echo -e "\e[34m		*******************************"
		echo -e "\e[92m		5. \e[39mCrear Productos"
		echo -e "\e[92m		6. \e[39mEditar Productos"
		echo -e "\e[92m		7. \e[39mEliminar Productos"
		echo -e "\e[92m		8. \e[39mConsultar Productos"
		echo -e "\e[34m		*******************************"
		echo -e "\e[39m			INVENTARIO"
		echo -e "\e[34m		*******************************"
		echo -e "\e[92m		9. \e[39mAgregar inventario"
		echo -e "\e[92m		10. \e[39mDisminuir inventario"
		echo -e "\e[34m		*******************************"
		echo -e "\e[39m			ADMINISTRACIÓN"
		echo -e "\e[34m		*******************************"
		echo -e "\e[92m		0. \e[39mCerrar aplicación"
		echo -e " "
		echo -e "\e[34m	============================================================\e[39m"
		read -p $'		\e[92mIngrese opción:\e[39m ' pasoF	
		echo -e "\e[34m	============================================================\e[39m"
		echo -e " "
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
	echo -e "\e[34m "
	echo -e "\e[34m-------------------------------------------------------------------"
	echo -e "\e[39m Ejecución terminada. Hasta Pronto!"
	echo -e "\e[39m Fecha fin proceso " $dia " " $hora
	echo -e "\e[34m-------------------------------------------------------------------\e[39m"
	exit 0
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la creación de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_CrearCategoria(){
	#============================================
	# Creación del archivo categorías
	#============================================
	if [ ! -f $txtCategorias ];
	then
		touch $txtCategorias
		chmod 775 $txtCategorias
	fi
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m		Una vez hayas finalizado de ingresar las "
	echo -e "\e[39m		categorías escribe la palabra \e[92m<<SALIR>>"
	echo -e "\e[34m	==================================================================\e[39m"
	nomCategoria=""
	while [[ "$nomCategoria" != "SALIR" ]]
	do
		echo -e "\e[34m		-------------------------------\e[39m"
		read -p $'		\e[92mNombre:\e[39m ' nomCategoria
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
					codCategoria=$(cat $txtCategorias | wc -l)
					codCategoria=$((codCategoria+1))
					#=================================
					# Construcción Categoria
					# codCat;nombre;activo
					#=================================
					strFinCategoria=$codCategoria";"$nomCategoria";1"
					echo $strFinCategoria>>$txtCategorias
					fun_RegistrarLog "1" "$strFinCategoria"
				else
					echo -e "\e[91m		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
					echo -e "\e[39m			La categoría ya se encuentra registrada"
					echo -e "\e[91m		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}\e[39m"
				fi
			fi
		else
			echo -e "\e[91m		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
			echo -e "\e[39m			La longitud máxima son \e[91m$longNomCategoria\e[39m caracteres"
			echo -e "\e[91m		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		fi
	done
	echo -e "\e[92m		**************************************************"
	echo -e "\e[39m			Categorías registradas con exito"
	echo -e "\e[92m		**************************************************\e[39m"	
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la edición de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EditarCategoria(){
	fun_SeleccionarCategoria
	if [ $swExiste = 1 ];
	then
		strNomViejo=$(cat $txtCategorias | sed -n $cat_Cod"p")
		strNomViejoUni=$(cut -d ';' -f2 <<<"$strNomViejo")
		echo -e "\e[34m "
		echo -e "\e[34m		------------------------------------------\e[39m"
		echo -e "\e[92m		Nombre anterior: \e[39m"$strNomViejoUni
		read -p $'\e[92m		Nombre Nuevo: \e[39m' strNomNuevo
		strNomNuevo=$(echo "$strNomNuevo" | tr '[:lower:]' '[:upper:]')
		strNomNuevo=$cat_Cod";"$strNomNuevo";1"
		echo $(sed -i 's/'$strNomViejo'/'$strNomNuevo'/g' $txtCategorias)
		fun_RegistrarLog "2" "OLD:$strNomViejo-NEW:$strNomNuevo"
		echo -e "\e[92m "
		echo -e "\e[92m		**************************************************"
		echo -e "\e[39m			Categoría editada con éxito"
		echo -e "\e[92m		**************************************************\e[39m"

	fi
	echo " "
	read -p $'		Presiona la tecla \e[92mENTER\e[39m para continuar... ' a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la eliminación de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EliminarCategoria(){
	fun_SeleccionarCategoria
	if [ $swExiste = 1 ];
	then
		strNomViejo=$(cat $txtCategorias | sed -n $cat_Cod"p")
		indExisteProd=0
		fun_BuscarProductoCategoria "$cat_Cod"
		if [ $indExisteProd = 1 ];
		then 
			echo -e "\e[93m "
			echo -e "\e[93m			¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬"
			echo -e "\e[39m			Existen productos asociados a la categoría seleccionada"
			echo -e "\e[93m			¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬\e[39m"
		fi 
		respuesta="Q"
		while [[ "$respuesta" != "S" && "$respuesta" != "N" ]]
		do
			read -p $'		¿Desea eliminar la categoria? \e[92m[S|N]\e[39m: ' respuesta
			respuesta=$(echo "$respuesta" | tr '[:lower:]' '[:upper:]')
		done
		if [ "$respuesta" = "S" ];
		then
			nomCategoria="$(cut -d ';' -f2 <<<"$strNomViejo")"
			strNomNuevo=$cat_Cod";"$nomCategoria";0"
			echo $(sed -i 's/'$strNomViejo'/'$strNomNuevo'/g' $txtCategorias)
			fun_RegistrarLog "3" "$strNomNuevo"
			echo -e "\e[92m			**************************************************"
			echo -e "\e[39m				Se elimina la categoría <<$nomCategoria>>"
			echo -e "\e[92m			**************************************************\e[39m"
		fi
	fi
	echo " "
	read -p $'		Presiona la tecla \e[92mENTER\e[39m para continuar... ' a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la consulta de las categorías
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ConsultarCategoria(){
	fun_ListarCategorias
	echo " "
	read -p $'		Presiona la tecla \e[92mENTER\e[39m para continuar... ' a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la creación de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_CrearProducto(){
	#============================================
	# Creación del archivo de productos
	#============================================
	if [ ! -f $txtProductos ];
	then
		touch $txtProductos
		chmod 775 $txtProductos
	fi

	#============================================
	# Creación del archivo categorías
	#============================================
	if [ ! -f $txtCategorias ];
	then
		fun_CrearCategoria
	fi

	#============================================
	# Selección de la categoria
	#============================================
	echo -e "\e[34m 	"
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m		PASO 1. Categorías disponibles"
	echo -e "\e[34m	==================================================================\e[39m"
	fun_SeleccionarCategoria

	#============================================
	# Selección del genero
	#============================================
	echo -e "\e[34m 	"
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m		PASO 2. Selecciona el género"
	echo -e "\e[34m	==================================================================\e[39m"
	strGenero="Q"
	while [[ "$strGenero" != "H" && "$strGenero" != "M" && "$strGenero" != "U" ]]
	do
		if [ "$strGenero" != "Q" ];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Opción $strGenero NO es valida "
			echo -e "\e[91m		-------------------------------------\e[39m"
		fi
		echo -e "\e[92m		(H) \e[39mHOMBRE"
		echo -e "\e[92m		(M) \e[39mMUJER"
		echo -e "\e[92m		(U) \e[39mUNISEX"
		read -p "		Ingresa la letra del género: " strGenero
		strGenero=$(echo $strGenero | tr '[:lower:]' '[:upper:]')
	done
	
	#============================================
	# Datos basicos del producto
	#============================================
	echo -e "\e[34m 	"
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m		PASO 3. Datos basicos del producto"
	echo -e "\e[34m	==================================================================\e[39m"
	#--------------------------------------------
	#	Código del producto
	#--------------------------------------------
	cantEspacios=$((longCodigo+5))
	while [[ $cantEspacios -gt $longCodigo ]]
	do
		read -p $'\e[92m		Código:\e[39m ' strCodigo
		if [  ! "$strCodigo"  ];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Debes ingresar un código"
			echo -e "\e[91m		-------------------------------------\e[39m"
		else
			cantEspacios=$(echo ${#strCodigo})
			if [ $cantEspacios -gt $longCodigo ];
			then
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
					echo -e "\e[91m		-------------------------------------"
			fi
		fi
	done

	#--------------------------------------------
	#	Nombre del producto
	#--------------------------------------------
	cantEspacios=$((longNomProducto+5))
	while [[ $cantEspacios -gt $longNomProducto ]]
	do
		read -p $'\e[92m		Nombre: \e[39m' strNomProducto
		strNomProducto=$(echo $strNomProducto | tr '[:lower:]' '[:upper:]')
		if [  ! "$strNomProducto"  ];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Debes ingresar un nombre"
			echo -e "\e[91m		-------------------------------------\e[39m"
		else
			cantEspacios=$(echo ${#strNomProducto})
			if [ $cantEspacios -gt $longNomProducto ];
			then
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
					echo -e "\e[91m		-------------------------------------"
			fi
		fi
	done

	#--------------------------------------------
	#	Valor de compra del producto
	#--------------------------------------------
	cantEspacios=$((longVlrCompra+5))
	while [[ $cantEspacios -gt $longVlrCompra || "$strValCompra" -lt "$valMinimo" ]]
	do
		read -p $'\e[92m		Valor Compra: \e[39m' strValCompra
		if [[ ! "$strValCompra" || "$strValCompra" -lt "$valMinimo" ]];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Debes ingresar un valor y >= a \e[91m$valMinimo"
			echo -e "\e[91m		-------------------------------------\e[39m"	
		else
			cantEspacios=$(echo ${#strValCompra})
			if [ $cantEspacios -gt $longVlrCompra ];
			then
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
					echo -e "\e[91m		-------------------------------------"
			fi
		fi
	done

	#--------------------------------------------
	#	Valor de venta del producto
	#--------------------------------------------
	cantEspacios=$((longVlrVenta+5))
	while [[ $cantEspacios -gt $longVlrVenta || "$strValVenta" -lt "$strValCompra" ]]
	do
		read -p $'\e[92m		Valor Venta: \e[39m' strValVenta
		if [[ ! "$strValVenta" || "$strValVenta" -lt "$strValCompra" ]];
		then			
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Debes ingresar un valor y >= a \e[91m$valMinimo"
			echo -e "\e[91m		-------------------------------------\e[39m"
		else
			cantEspacios=$(echo ${#strValVenta})
			if [ $cantEspacios -gt $longVlrVenta ];
			then
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
					echo -e "\e[91m		-------------------------------------"
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
		echo $strFinProducto>>$txtProductos
		fun_RegistrarLog "4" "$strFinProducto"
		echo -e "\e[92m		**************************************************"
		echo -e "\e[39m			Producto registrado con éxito"
		echo -e "\e[92m		**************************************************\e[39m"
	else
		echo -e "\e[91m		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		echo -e "\e[39m			El producto ya se encuentra registrado"
		echo -e "\e[91m		{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}\e[39m"
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
		
		echo -e "\e[34m "
		echo -e "\e[34m		------------------------------------------"
		echo -e "\e[39m				Categoría"
		echo -e "\e[34m		------------------------------------------\e[39m"
		while [[ "$RespCategoria" != "S" && "$RespCategoria" != "N" ]]
		do
			read -p $'		¿Dese editar la categoría? \e[92m[S|N]\e[39m: ' RespCategoria
			RespCategoria=$(echo "$RespCategoria" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespCategoria = "S" ];
		then 
			echo -e "\e[92m		Actual: \e[39m"$prd_nomCat
			fun_SeleccionarCategoria
			strNewCategoria=$strOrden
		fi
		
		echo -e "\e[34m "
		echo -e "\e[34m		------------------------------------------"
		echo -e "\e[39m				Nombre"
		echo -e "\e[34m		------------------------------------------\e[39m"
		while [[ "$RespNombre" != "S" && "$RespNombre" != "N" ]]
		do
			read -p $'		¿Dese editar el nombre? \e[92m[S|N]\e[39m: ' RespNombre
			RespNombre=$(echo "$RespNombre" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespNombre = "S" ];
		then 
			echo -e "\e[92m		Actual: \e[39m"$prd_nombre
			cantEspacios=$((longNomProducto+5))
			while [[ $cantEspacios -gt $longNomProducto ]]
			do
				read -p $'		\e[92mNuevo:\e[39m ' strNewNombre
				strNewNombre=$(echo $strNewNombre | tr '[:lower:]' '[:upper:]')
				if [  ! "$strNewNombre"  ];
				then
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		Debes ingresar un nombre"
					echo -e "\e[91m		-------------------------------------\e[39m"
				else
					cantEspacios=$(echo ${#strNewNombre})
					if [ $cantEspacios -gt $longNomProducto ];
					then
							echo -e "\e[91m		-------------------------------------"
							echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
							echo -e "\e[91m		-------------------------------------"
					fi
				fi
			done
		fi

		echo -e "\e[34m "
		echo -e "\e[34m		------------------------------------------"
		echo -e "\e[39m				Género"
		echo -e "\e[34m		------------------------------------------\e[39m"
		while [[ "$RespGenero" != "S" && "$RespGenero" != "N" ]]
		do
			read -p $'		¿Dese editar el género? \e[92m[S|N]\e[39m: ' RespGenero
			RespGenero=$(echo "$RespGenero" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespGenero = "S" ];
		then 
			echo -e "\e[92m		Actual: \e[39m"$prd_genero
			strNewGenero="Q"
			while [[ "$strNewGenero" != "H" && "$strNewGenero" != "M" && "$strNewGenero" != "U" ]]
			do
				if [ "$strNewGenero" != "Q" ];
				then
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		Opción $strNewGenero NO es valida "
					echo -e "\e[91m		-------------------------------------\e[39m"
				fi
				echo -e "\e[92m		(H)\e[39m HOMBRE"
				echo -e "\e[92m		(M)\e[39m MUJER"
				echo -e "\e[92m		(U)\e[39m UNISEX"
				read -p "		Ingresa la letra del género: " strNewGenero
				strNewGenero=$(echo $strNewGenero | tr '[:lower:]' '[:upper:]')
			done
		fi

		echo -e "\e[34m "
		echo -e "\e[34m		------------------------------------------"
		echo -e "\e[39m				Valor Compra"
		echo -e "\e[34m		------------------------------------------\e[39m"
		while [[ "$RespVlrCompra" != "S" && "$RespVlrCompra" != "N" ]]
		do
			read -p $'		¿Dese editar el valor de compra? \e[92m[S|N]\e[39m: ' RespVlrCompra
			RespVlrCompra=$(echo "$RespVlrCompra" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespVlrCompra = "S" ];
		then 
			echo -e "\e[92m		Actual: \e[39m"$prd_valCompra
			cantEspacios=$((longVlrCompra+5))
			while [[ $cantEspacios -gt $longVlrCompra || "$strNewVlrCompra" -lt "$valMinimo" ]]
			do
				read -p $'\e[92m		Valor Compra: \e[39m' strNewVlrCompra
				if [[ ! "$strNewVlrCompra" || "$strNewVlrCompra" -lt "$valMinimo" ]];
				then 
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		Debes ingresar un valor y >= a \e[91m$valMinimo"
					echo -e "\e[91m		-------------------------------------\e[39m"	
				else
					cantEspacios=$(echo ${#strNewVlrCompra})
					if [ $cantEspacios -gt $longVlrCompra ];
					then
							echo -e "\e[91m		-------------------------------------"
							echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
							echo -e "\e[91m		-------------------------------------"
					fi
				fi
			done
		else
			strNewVlrCompra=$prd_valCompra
		fi

		echo -e "\e[34m "
		echo -e "\e[34m		------------------------------------------"
		echo -e "\e[39m				Valor Venta"
		echo -e "\e[34m		------------------------------------------\e[39m"
		while [[ "$RespVlrVenta" != "S" && "$RespVlrVenta" != "N" ]]
		do
			read -p $'		¿Dese editar el valor de venta? \e[92m[S|N]\e[39m: ' RespVlrVenta
			RespVlrVenta=$(echo "$RespVlrVenta" | tr '[:lower:]' '[:upper:]')
		done
		if [ $RespVlrVenta = "S" ];
		then
			echo -e "\e[92m		Actual: \e[39m"$prd_valVenta
			cantEspacios=$((longVlrVenta+5))
			while [[ $cantEspacios -gt $longVlrVenta || "$strNewVlrVenta" -lt "$strNewVlrCompra" ]]
			do
				read -p $'\e[92m		Valor Venta: \e[39m' strNewVlrVenta
				if [[ ! "$strNewVlrVenta" || "$strNewVlrVenta" -lt "$strNewVlrCompra" ]];
				then 
					echo -e "\e[91m		-------------------------------------"
					echo -e "\e[39m		Debes ingresar un valor y >= a \e[91m$strNewVlrCompra"
					echo -e "\e[91m		-------------------------------------\e[39m"
				else
					cantEspacios=$(echo ${#strNewVlrVenta})
					if [ $cantEspacios -gt $longVlrVenta ];
					then
							echo -e "\e[91m		-------------------------------------"
							echo -e "\e[39m		La longitud máxima son \e[91m$longCodigo\e[39m caracteres"
							echo -e "\e[91m		-------------------------------------"
					fi
				fi
			done
		fi

		strProdActual=$strProducto
		strProdNuevo=$prd_Cod";"$strNewCategoria";"$strNewNombre";"$strNewGenero";"$prd_cantidad";"$strNewVlrCompra";"$strNewVlrVenta";1"
		echo $(sed -i s/$strProdActual/$strProdNuevo/g $txtProductos)
		fun_RegistrarLog "5" "OLD:$strProdActual-NEW:$strProdNuevo"
		echo " "
		echo -e "\e[92m		**************************************************"
		echo -e "\e[39m			Producto editado con éxito"
		echo -e "\e[92m		**************************************************\e[92m"
		unset RespCategoria
		unset RespNombre
		unset RespGenero
		unset RespVlrCompra
		unset RespVlrVenta
	fi
	echo " "
	read -p $'		Presiona la tecla \e[92mENTER\e[39m para continuar... ' a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la eliminación de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_EliminarProducto(){
	fun_SeleccionarProducto
	if [ $swExiste = 1 ];
	then
		respuesta="Q"
		while [[ "$respuesta" != "S" && "$respuesta" != "N" ]]
		do
			read -p $'		¿Desea eliminar el producto \e[92m<<$prd_nombre>>? [S|N]\e[39m: ' respuesta
			respuesta=$(echo "$respuesta" | tr '[:lower:]' '[:upper:]')
		done
		if [ "$respuesta" = "S" ];
		then
			strProdActual=$strProducto
			strProdNuevo=$prd_Cod";"$prd_codCat";"$prd_nombre";"$prd_genero";"$prd_cantidad";"$prd_valCompra";"$prd_valVenta";0"
			echo $(sed -i s/$strProdActual/$strProdNuevo/g $txtProductos)
			fun_RegistrarLog "4" "$strProdNuevo"
			echo " "
			echo -e "\e[92m		**************************************************"
			echo -e "\e[39m			Producto eliminado con éxito"
			echo -e "\e[92m		**************************************************\e[39m"
		fi
	fi
	echo " "
	read -p $'		Presiona la tecla \e[92mENTER\e[39m para continuar... ' a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que realiza la consulta de los productos
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_ConsultarProducto(){
	fun_ListarProductos
	echo " "
	read -p $'		Presiona la tecla \e[92mENTER\e[39m para continuar... ' a
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	FFunción que aumenta el inventario de un producto
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_AgregarInventario(){
	#============================================
	# Creación del archivo de compras
	#============================================
	if [ ! -f $txtCompras ];
	then
		touch $txtCompras
		chmod 775 $txtCompras
	fi
	fun_SeleccionarCategoria
	strCodCategoria=$cat_Cod
	fun_ListarProductos "$strCodCategoria"
	echo -e "\e[93m		=================================================================="
	echo -e "\e[39m			Registro de compra"
	echo -e "\e[93m		==================================================================\e[39m"
	echo -e " "
	echo -e "\e[93m			*********************************************"
	echo -e "\e[39m 			Datos básicos"
	echo -e "\e[93m			*********************************************"
	echo -e "				\e[92m1. Categoría producto:\e[39m "$cat_nombre
	cantEspacios=$((longCompra+5))
	while [[ $cantEspacios -gt $longCompra ]]
	do
		read -p $'				\e[92m2. Código compra:\e[39m ' comCodCompra
		if [  ! "$comCodCompra"  ];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Debes ingresar un código"
			echo -e "\e[91m		-------------------------------------\e[39m"
		else
			cantEspacios=$(echo ${#comCodCompra})
			if [ $cantEspacios -gt $longCompra ];
			then
					echo -e "\e[91m				-------------------------------------"
					echo -e "\e[39m				La longitud máxima son \e[91m$longCompra\e[39m caracteres"
					echo -e "\e[91m				-------------------------------------"
			fi
		fi
	done
	echo -e "\e[93m			*********************************************"
	echo -e "\e[39m 			Productos"
	echo -e "\e[93m			*********************************************"
	respProduc="S"
	impCompra=""
	detCompra=""
	if [ ! -f $txtAuxiliarV ];
	then
		touch $txtAuxiliarV
		chmod 775 $txtAuxiliarV
	fi
	if [ ! -f $txtAuxiliarB ];
	then
		touch $txtAuxiliarB
		chmod 775 $txtAuxiliarB
	fi
	true>$txtAuxiliarB
	while [ "$respProduc" = "S" ]
	do
		unset impCompra
		unset detCompra
		echo -e " "
		indExisteProd=0
		while [ $indExisteProd = 0 ]
		do
			read -p $'				\e[92m3. Código producto:\e[39m ' comCodProducto
			fun_BuscarProductoCodigo "$comCodProducto"
			if [ $indExisteProd = 0 ];
			then
				echo -e "\e[91m		-------------------------------------"
				echo -e "\e[39m		Código producto \e[91m$comCodProducto\e[39m NO existe"
				echo -e "\e[91m		-------------------------------------\e[39m"
			fi
		done
		comCantCompra=0
		while [ $comCantCompra -le 0 ]
		do
			read -p $'				\e[92m4. Cantidad compra:\e[39m ' comCantCompra
			if [ $comCantCompra -le 0 ];
			then 
				echo -e "\e[91m				-------------------------------------"
				echo -e "\e[39m				Cantidad Compra debe ser > a \e[91m0\e[39m"
				echo -e "\e[91m				-------------------------------------\e[39m"
			fi
		done
		echo -e " "
		respProduc="q"
		while [[ "$respProduc" != "S" && "$respProduc" != "N" ]]
		do
			read -p $'		¿Desea agregar más productos? \e[92m[S|N]\e[39m: ' respProduc
			respProduc=$(echo "$respProduc" | tr '[:lower:]' '[:upper:]')
		done
		
		cantEspacios=$(echo ${#comCodCompra})
		cantEspacios=$((longCompra-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impCompra=$impCompra$(echo "\e[34m|\e[39m"$comCodCompra"\e[39m"$strEspacios"\e[34m|\e[39m")
		detCompra=$comCodCompra";"

		cantEspacios=$(echo ${#cat_nombre})
		cantEspacios=$((longNomCategoria-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impCompra=$impCompra$(echo $cat_nombre$strEspacios"\e[34m|\e[39m")
		detCompra=$detCompra$strCodCategoria";"

		cantEspacios=$(echo ${#prd_nombre})
		cantEspacios=$((longNomProducto-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impCompra=$impCompra$(echo $prd_nombre$strEspacios"\e[34m|\e[39m")
		detCompra=$detCompra$prd_Cod";"

		cantEspacios=$(echo ${#comCantCompra})
		cantEspacios=$((longCantidad-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impCompra=$impCompra$(echo $comCantCompra$strEspacios"\e[34m|\e[39m")
		detCompra=$detCompra$comCantCompra";"
		echo $impCompra>>$txtAuxiliarV
		echo $detCompra>>$txtAuxiliarB
	done
	echo -e " "
	echo -e "\e[93m			*********************************************"
	echo -e "\e[39m 			Resumen Compra"
	echo -e "\e[93m			*********************************************"
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "		\e[34m|\e[39m       CÓDIGO       \e[34m|\e[39m   CATEGORÍA   \e[34m|\e[39m         PRODUCTO        \e[34m|\e[39m CANTIDAD \e[34m|\e[39m"
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	
	while IFS= read -r linea
	do
		echo -e "		"$linea
	done < $txtAuxiliarV

	while IFS= read -r linea
	do
		codCompra="$(cut -d ';' -f1 <<<"$linea")"
		echo $linea>>$txtCompras
		catNomCompra="$(cut -d ';' -f2 <<<"$linea")"
		proCodCompra="$(cut -d ';' -f3 <<<"$linea")"
		cantCompra="$(cut -d ';' -f4 <<<"$linea")"
		fun_BuscarProductoCodigo proCodCompra
		
		prd_Cod="$(cut -d ';' -f1 <<<"$lineaProducto")"
		prd_codCat="$(cut -d ';' -f2 <<<"$lineaProducto")"
		prd_codCat=$prd_codCat
		prd_nomCat=$(cat $txtCategorias | sed -n $prd_codCat"p")
		prd_nomCat="$(cut -d ';' -f2 <<<"$prd_nomCat")"
		prd_nombre="$(cut -d ';' -f3 <<<"$lineaProducto")"
		prd_genero="$(cut -d ';' -f4 <<<"$lineaProducto")"
		prd_cantidad="$(cut -d ';' -f5 <<<"$lineaProducto")"
		prd_valCompra="$(cut -d ';' -f6 <<<"$lineaProducto")"
		prd_valVenta="$(cut -d ';' -f7 <<<"$lineaProducto")"
		prd_activo="$(cut -d ';' -f8 <<<"$lineaProducto")"

		prd_cantidad=$((prd_cantidad+cantCompra))

		strProdVenta=$(echo $prd_Cod";"$prd_codCat";"$prd_nombre";"$prd_genero";"$prd_cantidad";"$prd_valCompra";"$prd_valVenta";"$prd_activo)
		echo $(sed -i s/$lineaProducto/$strProdVenta/g $txtProductos)
		fun_RegistrarLog "7" "$linea"
	done < $txtAuxiliarB
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	echo " "
	echo -e "\e[92m		**************************************************"
	echo -e "\e[39m			Compra registrada con éxito"
	echo -e "\e[92m		**************************************************\e[39m"

}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	FFunción que disminuye el inventario de un producto
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_DisminuirInventario(){
	#============================================
	# Creación del archivo de compras
	#============================================
	if [ ! -f $txtVentas ];
	then
		touch $txtVentas
		chmod 775 $txtVentas
	fi
	fun_SeleccionarCategoria
	strCodCategoria=$cat_Cod
	fun_ListarProductos "$strCodCategoria"
	echo -e "\e[93m		=================================================================="
	echo -e "\e[39m			Registro de venta"
	echo -e "\e[93m		==================================================================\e[39m"
	echo -e " "
	echo -e "\e[93m			*********************************************"
	echo -e "\e[39m 			Datos básicos"
	echo -e "\e[93m			*********************************************"
	echo -e "				\e[92m1. Categoría producto:\e[39m "$cat_nombre
	cantEspacios=$((longCompra+5))
	while [[ $cantEspacios -gt $longCompra ]]
	do
		read -p $'				\e[92m2. Cliente:\e[39m ' codCliente
		if [  ! "$codCliente"  ];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Debes ingresar un cliente"
			echo -e "\e[91m		-------------------------------------\e[39m"
		else
			cantEspacios=$(echo ${#codCliente})
			if [ $cantEspacios -gt $longCliente ];
			then
					echo -e "\e[91m				-------------------------------------"
					echo -e "\e[39m				La longitud máxima son \e[91m$longCompra\e[39m caracteres"
					echo -e "\e[91m				-------------------------------------"
			fi
		fi
	done
	echo -e "\e[93m			*********************************************"
	echo -e "\e[39m 			Productos"
	echo -e "\e[93m			*********************************************"
	respProduc="S"
	impVenta=""
	detVenta=""
	if [ ! -f $txtAuxiliarV ];
	then
		touch $txtAuxiliarV
		chmod 775 $txtAuxiliarV
	fi
	if [ ! -f $txtAuxiliarB ];
	then
		touch $txtAuxiliarB
		chmod 775 $txtAuxiliarB
	fi
	true>$txtAuxiliarB
	while [ "$respProduc" = "S" ]
	do
		unset impVenta
		unset detVenta
		echo -e " "
		indExisteProd=0
		while [ $indExisteProd = 0 ]
		do
			read -p $'				\e[92m3. Código producto:\e[39m ' comCodProducto
			fun_BuscarProductoCodigo "$comCodProducto"
			if [ $indExisteProd = 0 ];
			then
				echo -e "\e[91m		-------------------------------------"
				echo -e "\e[39m		Código producto \e[91m$comCodProducto\e[39m NO existe"
				echo -e "\e[91m		-------------------------------------\e[39m"
			fi
		done
		comCantCompra=0
		while [ $comCantCompra -le 0 ]
		do
			read -p $'				\e[92m4. Cantidad venta:\e[39m ' comCantCompra
			if [ $comCantCompra -le 0 ];
			then 
				echo -e "\e[91m				-------------------------------------"
				echo -e "\e[39m				Cantidad Venta debe ser > a \e[91m0\e[39m"
				echo -e "\e[91m				-------------------------------------\e[39m"
			fi
		done
		echo -e " "
		respProduc="q"
		while [[ "$respProduc" != "S" && "$respProduc" != "N" ]]
		do
			read -p $'		¿Desea vender más productos? \e[92m[S|N]\e[39m: ' respProduc
			respProduc=$(echo "$respProduc" | tr '[:lower:]' '[:upper:]')
		done
		
		cantEspacios=$(echo ${#codCliente})
		cantEspacios=$((longCliente-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impVenta=$impVenta$(echo "\e[34m|\e[39m"$codCliente"\e[39m"$strEspacios"\e[34m|\e[39m")
		detVenta=$codCliente";"

		cantEspacios=$(echo ${#cat_nombre})
		cantEspacios=$((longNomCategoria-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impVenta=$impVenta$(echo $cat_nombre$strEspacios"\e[34m|\e[39m")
		detVenta=$detVenta$strCodCategoria";"

		cantEspacios=$(echo ${#prd_nombre})
		cantEspacios=$((longNomProducto-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impVenta=$impVenta$(echo $prd_nombre$strEspacios"\e[34m|\e[39m")
		detVenta=$detVenta$prd_Cod";"

		cantEspacios=$(echo ${#comCantCompra})
		cantEspacios=$((longCantidad-cantEspacios))
		strEspacios=""
		funEspacios $cantEspacios
		impVenta=$impVenta$(echo $comCantCompra$strEspacios"\e[34m|\e[39m")
		detVenta=$detVenta$comCantCompra";"
		echo $impVenta>>$txtAuxiliarV
		echo $detVenta>>$txtAuxiliarB
	done
	echo -e " "
	echo -e "\e[93m			*********************************************"
	echo -e "\e[39m 			Resumen Compra"
	echo -e "\e[93m			*********************************************"
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "		\e[34m|\e[39m            CLIENTE           \e[34m|\e[39m   CATEGORÍA   \e[34m|\e[39m         PRODUCTO        \e[34m|\e[39m CANTIDAD \e[34m|\e[39m"
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	
	while IFS= read -r linea
	do
		echo -e "		"$linea
	done < $txtAuxiliarV

	while IFS= read -r linea
	do
		codCompra="$(cut -d ';' -f1 <<<"$linea")"
		echo $linea>>$txtVentas
		catNomCompra="$(cut -d ';' -f2 <<<"$linea")"
		proCodCompra="$(cut -d ';' -f3 <<<"$linea")"
		cantCompra="$(cut -d ';' -f4 <<<"$linea")"
		fun_BuscarProductoCodigo proCodCompra
		
		prd_Cod="$(cut -d ';' -f1 <<<"$lineaProducto")"
		prd_codCat="$(cut -d ';' -f2 <<<"$lineaProducto")"
		prd_codCat=$prd_codCat
		prd_nomCat=$(cat $txtCategorias | sed -n $prd_codCat"p")
		prd_nomCat="$(cut -d ';' -f2 <<<"$prd_nomCat")"
		prd_nombre="$(cut -d ';' -f3 <<<"$lineaProducto")"
		prd_genero="$(cut -d ';' -f4 <<<"$lineaProducto")"
		prd_cantidad="$(cut -d ';' -f5 <<<"$lineaProducto")"
		prd_valCompra="$(cut -d ';' -f6 <<<"$lineaProducto")"
		prd_valVenta="$(cut -d ';' -f7 <<<"$lineaProducto")"
		prd_activo="$(cut -d ';' -f8 <<<"$lineaProducto")"

		prd_cantidad=$((prd_cantidad-cantCompra))

		strProdVenta=$(echo $prd_Cod";"$prd_codCat";"$prd_nombre";"$prd_genero";"$prd_cantidad";"$prd_valCompra";"$prd_valVenta";"$prd_activo)
		echo $(sed -i s/$lineaProducto/$strProdVenta/g $txtProductos)
		fun_RegistrarLog "8" "$linea"
	done < $txtAuxiliarB
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	echo " "
	echo -e "\e[92m		**************************************************"
	echo -e "\e[39m			Venta registrada con éxito"
	echo -e "\e[92m		**************************************************\e[39m"
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
			prd_nombre="$(cut -d ';' -f3 <<<"$linea")"
			indExisteProd=1
			lineaProducto=$linea
		fi
	done < $txtProductos
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
	done < $txtProductos
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
	done < $txtCategorias
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
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Opción \e[91m$strOrden\e[39m NO es valida "
			echo -e "\e[91m		-------------------------------------\e[39m"
		fi
		orden=1
		fun_ListarCategorias
		if [ $swExiste = 1 ];
		then
			read -p $'		Ingresa el \e[92mnúmero\e[39m de la categoría que desea: ' strOrden
			if [[ "$strOrden" -ge "1" && "$strOrden" -le "$orden" ]];
			then			
				strCategoria=$(cat $txtCategorias | sed -n $strOrden"p")
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
	echo -e "\e[34m 	"
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m		Categorías Existentes"
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m "
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "		\e[34m|\e[39m  CÓDIGO  \e[34m|\e[39m   CATEGORÍA   \e[34m|\e[39m"
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	swExiste=0
	if [ -f $txtCategorias ];
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
				impCategorias=$impCategorias$(echo -e "\e[34m|\e[92m"$cat_Cod"\e[39m"$strEspacios"\e[34m|\e[39m")

				cat_nombre="$(cut -d ';' -f2 <<<"$lineaCt")"
				cantEspacios=$(echo ${#cat_nombre})
				cantEspacios=$((longNomCategoria-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impCategorias=$impCategorias$(echo -e $cat_nombre$strEspacios"\e[34m|\e[39m")

				echo "		"$impCategorias	
			fi
		done < $txtCategorias
	fi
	if [ $swExiste = 0 ];
	then
		echo -e "		\e[34m|\e[39m     NO HAY CATEGORÍAS    \e[34m|\e[39m"
		swCiclo=0
	fi
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#	Función que selecciona el producto deseado
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
fun_SeleccionarProducto(){
	strOrden=-1
	swCiclo=1
	if [ $1 ];
	then
		codigoCategoria=$1
	else
		codigoCategoria="NA"
	fi
	while [[ "$swCiclo" != "0" ]]
	do

		if [ "$strOrden" != "-1" ];
		then
			echo -e "\e[91m		-------------------------------------"
			echo -e "\e[39m		Opción \e[91m$strOrden\e[39m NO es valida "
			echo -e "\e[91m		-------------------------------------"
		fi
		orden=1
		fun_ListarProductos "$codigoCategoria"
		if [[ $swExiste = 1 && $contProducto -gt 0 ]];
		then
			read -p $'		Ingresa el \e[92mnúmero\e[39m del producto que desea: ' strOrden
			if [[ "$strOrden" -ge "1" && "$strOrden" -le "$orden" ]];
			then
				strProducto=$(cat $txtProductos | sed -n $strOrden"p")			
				prd_Cod="$(cut -d ';' -f1 <<<"$strProducto")"
				prd_codCat="$(cut -d ';' -f2 <<<"$strProducto")"
				prd_codCat=$prd_codCat
				prd_nomCat=$(cat $txtCategorias | sed -n $prd_codCat"p")
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
	echo -e "\e[34m	=================================================================="
	echo -e "\e[39m		Productos Existentes"
	echo -e "\e[34m	==================================================================\e[39m"
	echo -e " "
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	echo -e "\e[34m		|\e[39m ORD \e[34m|\e[39m  CÓDIGO  \e[34m|\e[39m   CATEGORÍA   \e[34m|\e[39m          NOMBRE         \e[34m|\e[39m GÉNERO \e[34m|\e[39m CANTIDAD \e[34m|\e[39m VLR COMPR \e[34m|\e[39m VLR VENTA \e[34m|\e[39m"
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
	swExiste=0
	orden=1
	swCategoria=0
	contProducto=0
	if [ -f $txtProductos ];
	then 
		if [ $1 ];
		then
			if [ $1 != "NA" ];
			then
				codigoCategoria=$1
				swCategoria=1
			fi
		fi
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
				impProducto=$impProducto$(echo -e "\e[34m|\e[92m"$orden"\e[39m"$strEspacios"\e[34m|\e[39m")
				orden=$((orden+1))

				#---------------------------------------
				# Impresión del código
				#---------------------------------------				
				prd_Cod="$(cut -d ';' -f1 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_Cod})
				cantEspacios=$((longCodigo-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_Cod$strEspacios"\e[34m|\e[39m")

				#---------------------------------------
				# Impresión de la categoría
				#---------------------------------------
				prd_codCat="$(cut -d ';' -f2 <<<"$lineaCt")"
				prd_nomCat=$(cat $txtCategorias | sed -n $prd_codCat"p")
				prd_nomCat="$(cut -d ';' -f2 <<<"$prd_nomCat")"
				cantEspacios=$(echo ${#prd_nomCat})
				cantEspacios=$((longNomCategoria-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_nomCat$strEspacios"\e[34m|\e[39m")

				#---------------------------------------
				# Impresión del nombre
				#---------------------------------------
				prd_nombre="$(cut -d ';' -f3 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_nombre})
				cantEspacios=$((longNomProducto-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_nombre$strEspacios"\e[34m|\e[39m")

				#---------------------------------------
				# Impresión del genero
				#---------------------------------------
				prd_genero="$(cut -d ';' -f4 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_genero})
				cantEspacios=$((longGenero-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_genero$strEspacios"\e[34m|\e[39m")

				#---------------------------------------
				# Impresión de la cantidad
				#---------------------------------------
				prd_cantidad="$(cut -d ';' -f5 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_cantidad})
				cantEspacios=$((longCantidad-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_cantidad$strEspacios"\e[34m|\e[39m")

				#---------------------------------------
				# Impresión del valor compra
				#---------------------------------------
				prd_valCompra="$(cut -d ';' -f6 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_valCompra})
				cantEspacios=$((longVlrCompra-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_valCompra$strEspacios"\e[34m|\e[39m")

				#---------------------------------------
				# Impresión del valor compra
				#---------------------------------------
				prd_valVenta="$(cut -d ';' -f7 <<<"$lineaCt")"
				cantEspacios=$(echo ${#prd_valVenta})
				cantEspacios=$((longVlrCompra-cantEspacios))
				strEspacios=""
				funEspacios $cantEspacios
				impProducto=$impProducto$(echo -e $prd_valVenta$strEspacios"\e[34m|\e[39m")
				if [[ $swCategoria = 1 && $codigoCategoria = $prd_codCat ]];
				then
					echo "		"$impProducto
					contProducto=$((contProducto+1))
				elif [ $swCategoria = 0 ];
				then
					echo "		"$impProducto
					contProducto=$((contProducto+1))
				fi
			fi
		done < $txtProductos
	fi
	if [[ $swExiste = 0 || $contProducto = 0 ]];
	then
		echo -e "\e[34m		|\e[39m                                   NO HAY PRODUCTOS QUE MOSTRAR                                       \e[34m|\e[39m"
		swCiclo=0
	fi
	echo -e "\e[34m		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[39m"
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
# Función que copmplementa de espacios un texto para presentar en 
# pantalla, segun la longitud definida. 
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
funEspacios(){
	cantEspacios=$1
	for (( i=1; i<=$cantEspacios; i++ ))
	do 
		##strEspacios=$strEspacios" "
		strEspacios=$(echo -e $strEspacios"\e[30m·\e[39m")
	done
}

#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
# Función que registra el log de las operaciones criticas
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#----------------------------------------------
# TRAMA:
# fecha|acción|trama|usr|pass
#----------------------------------------------
#
# ACCIONES:
#	-------------------------------------
#	| # acción 	| Detalle				|
#	-------------------------------------
#	| 1			| Crear Producto 		|
#	| 2			| Editar Producto 		|
#	| 3			| Eliminar Producto		|
#	| 4			| Crear Categoría		|
#	| 5			| Editar Categoría		|
#	| 6			| Eliminar Categoría	|
#	| 7			| Adicionar Inventario	|
#	| 8			| Disminuir Inventario	|
#	-------------------------------------
#
#----------------------------------------------
fun_RegistrarLog(){
	#$strUsuario
	#$strPass
	dia=`date +"%Y%m%d"`
	hora=`date +"%H:%M"`
	strAccion=$1
	strTrama=$2
	echo $dia$hora"|"$strAccion"|"$strTrama"|"$strUsuario"|"$strPass
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
#-----------------------------------
# Nombres de archivos
#-----------------------------------
txtLog="LogProceso.log"
txtProductos="Productos.txt"
txtCategorias="Categorias.txt"
txtUsuarios="Usuarios.txt"
txtCompras="Compras.txt"
txtVentas="Ventas.txt"
txtAuxiliarV="auxiliarV.txt"
txtAuxiliarB="auxiliarB.txt"
#-----------------------------------
# Parametros
#-----------------------------------
longCodigo=10
longNomCategoria=15
longNomProducto=25
longGenero=8
longCantidad=10
longVlrCompra=11
longVlrVenta=11
valMinimo=10000
longCompra=20
longCliente=30
#-----------------------------------
# Resultados de consultas
#-----------------------------------
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
#-----------------------------------
# Variables de apoyo
#-----------------------------------
indExisteProd=0
indUsuarioVal=-1
indExisteCate=0
strNomCategoria=0
strCodCategoria=0
categ=""
strEspacios=""
swExiste=0

echo -e "\e[93m	############################################################"
echo -e "\e[93m	############################################################"
echo -e "\e[93m	######      ## ############ ########      ####### ##########"
echo -e "\e[93m	###### ####### ########## ### ##### ########### ### ########"
echo -e "\e[93m	######      ## ########## ### ##### ########### ### ########"
echo -e "\e[93m	###### ####### ########         ### #########         ######"
echo -e "\e[93m	###### ####### ######## ####### ### ######### ####### ######"
echo -e "\e[93m	###### #######      ## ######### ###      ## ######### #####"
echo -e "\e[93m	############################################################"
echo -e "\e[93m	############################################################"
echo -e "\e[39m	"

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
		echo -e "\e[91m			{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}"
		echo -e "\e[39m			Usuario/Contraseña incorrecta"
		echo -e "\e[91m			{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}{}\e[39m"
	fi
done
