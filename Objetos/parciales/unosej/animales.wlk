object nano {
  var energia = 100
  const responsable = "Ro"
  
  method energia() = energia
  
  method responsable() = responsable
  
  method comer(unosGramos) {
    energia += 2 * unosGramos
  }
  
  method galopar(unaDistancia) {
    energia -= unaDistancia
  }
  
  method estaFeliz() = true
}

object pepita {
  var energia = 100
  const responsable = "Gust"
  var dondeEsta = "General las heras"
  
  method energia() = energia
  
  method responsable() = responsable
  
  method dondeEsta() = dondeEsta
  
  method comer(unosGramos) {
    energia += unosGramos / 2
  }
  
  method volarHacia(unaCiudad) {
    dondeEsta = unaCiudad
    energia /= 2
  }
  
  method estaFeliz() = dondeEsta == "Lihuel Calel"
}

object kali {
  var energia = 100
  const property responsable = "Dani"
  var edad = 15
  
  method energia() = energia
  
  method edad() = edad
  
  method comer(unosGramos) {
    energia += unosGramos
  }
  method cumplirAnios() {
    edad += 1
  }
  method estaFeliz() = energia > 30
}
