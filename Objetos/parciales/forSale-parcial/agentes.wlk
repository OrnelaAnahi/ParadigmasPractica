class Agente{
    const operacionesCerradas = []
    const reservas = #{}

    method TotalDeComisiones(){
        return  self.comisionPorOperacionesCerrada().sum()
    }
    method comisionPorOperacionesCerrada()=operacionesCerradas.map({inmueble=>inmueble.comisionAgente()})

    method cantidadOperacionesCerradas() {
      return operacionesCerradas.size()
    }
    method cantidadDeReservas() {
      return reservas.size()
    }
    method cantidadDe(lista){
        lista.size()
    }
}
 
object inmobiliaria  {
  const empleados = #{}
  method mejorEmpleadoSegunCantidad(atributo){
    return empleados.max({empleado => empleado.cantidadDe(atributo)})
  }
  
}
// Class Cliente{

//     method solicitarReserva(agente, inmueble){
//         agente.reservar(inmueble)
//     }

//     method concretar(agente, inmueble){
//         agente.concretar(inmueble)
//     }
// }