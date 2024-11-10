import NoPuedeCumplirMision.NoPuedoCumplirMisionException

// POR AHORA EMPLEADO ES UNA INTERFAZ
class Empleado {
  const habilidades = #{}
  var salud
  var tipoEmpleado

 method tipoEmpleado(nuevoTipo) {
   tipoEmpleado = nuevoTipo
 }

  method esIncapacitado() = tipoEmpleado.saludCritica() > salud

  method tieneHabilidad(unaHabilidad){
    return habilidades.contains(unaHabilidad)
  }

  method puedeUsar(unaHabilidad){
    return not(self.esIncapacitado()) && self.tieneHabilidad(unaHabilidad)
  }

  method recibirDanio(danio){
    salud -= danio
  }
  method finalizarMision(unaMision){
    if(salud>0){
        self.completarMision(unaMision)
    }
  }
  
  method completarMision(unaMision){
    tipoEmpleado.completarMision(unaMision,self)
  }

  method aprenderHabilidad(habilidad) {
	habilidades.add(habilidad)
  }

}

object espia {
  method saludCritica() = 15
   method completarMision(unaMision, empleado) {
    unaMision.enseniarHabilidades(empleado)
  }
}

object oficinista {
  var cantidadDeEstrellas = 0
  
  method completarMision(unaMision, empleado) {
   cantidadDeEstrellas +=1 
   if(cantidadDeEstrellas==3){
    empleado.tipoEmpleado(espia)
   }
  }
  method saludCritica() = 40 - (5 * cantidadDeEstrellas)
}

class Jefe inherits Empleado {
  const asistentes = #{}
  override method tieneHabilidad(unaHabilidad){
    return super(unaHabilidad) || self.algunosDeSusEmpleadosPuedeUsar(unaHabilidad)
  }
  //puede no ser necesario esto 
  method algunosDeSusEmpleadosPuedeUsar(unaHabilidad){
    return asistentes.any({asistente=>asistente.tieneHabilidad(unaHabilidad)})
  }
}

class Mision {
    const habilidadesRequeridas = []
    const peligrosidad
    
    method serCumplidaPor(asignado){
        if(not(self.puedeSerCumplidaPor(asignado))){
            throw new NoPuedoCumplirMisionException(message = "La mision no se puede cumplir")
        }
        asignado.recibirDanio(peligrosidad)
        asignado.finalizarMision(self)
    }

    method puedeSerCumplidaPor(asignado) = habilidadesRequeridas.all({habilidad => asignado.tieneHabilidad(habilidad)})
    
    method enseniarHabilidades(empleado) {
		self.habilidadesQueNoPosee(empleado).forEach({hab => empleado.aprenderHabilidad(hab)})
	}
	
	method reuneHabilidadesRequeridas(asignado) =
		habilidadesRequeridas.all({hab => asignado.puedeUsar(hab)})
		
	method habilidadesQueNoPosee(empleado) =
		habilidadesRequeridas.filter({hab => not empleado.poseeHabilidad(hab)})
    // ES IMPORTANTE AL FINAL PQ SOLO IMPORTAN LAS HABILIDADES QUE NO TIENE PQ CAPAZ AL JEFE LE AGREGAS UNA HABILIDAD DEL SUBORDINADO
}

object equipo {
    const equipo = #{}
    
    method tieneHabilidad(unaHabilidad){
        equipo.any({empleado => empleado.tieneHabilidad(unaHabilidad)})
    }

    method recibirDanio(danioTotal) {
      equipo.forEach({empleado => empleado.recibirDanio(danioTotal/3)})
    }
    method finalizarMision(unaMision) {
        equipo.forEach({empleado => empleado.finalizarMision(unaMision)})
    }
}

