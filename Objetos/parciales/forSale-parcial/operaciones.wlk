class Alquiler {
    const mesesDeContrato 
     method comisionAgente(valorInmueble) = mesesDeContrato* valorInmueble / 50000

}

class Venta {
    var porcentajeComision
    method comisionAgente(valorInmueble) = valorInmueble*porcentajeComision
}

class Inmueble{
    const tamanioEnMetrosCuadrados
    const cantidadAmbientes
    var operacion 
    var reservado = false
    method comisionAgente() = operacion.comisionAgente(self.valorInmueble())
    method valorInmueble() 

}

class Casa inherits Inmueble{
    var valorInmueble
    override method  valorInmueble()  = valorInmueble
}

class Ph inherits Inmueble{
    override method valorInmueble()  = 14000 * tamanioEnMetrosCuadrados
}

class Departamento inherits Inmueble{
    override method valorInmueble()  = 350000 * cantidadAmbientes
}