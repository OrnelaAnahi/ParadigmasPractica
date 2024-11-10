class Pelicula{
    const nombre
    const elenco = #{}
    method nombre() = nombre
    method presupuesto()= elenco.sum({artista=>artista.sueldo()}) * 1.7 
    method ganancia() = self.recaudado() - self.presupuesto()
    method recaudado() = 1000000

    method rodarPelicula(){
        elenco.forEach({artista=>artista.actuar()})
    }
}

class PeliculaDeAccion inherits Pelicula{
    var cantidadDeVidriosRotos
    override method presupuesto() = super() + cantidadDeVidriosRotos*1000
}

class PeliculaDeDrama inherits Pelicula{
    method extraPorLetraDeNombre(){
        return nombre.length()*100000
    }
    override method recaudado() = super() + self.extraPorLetraDeNombre()
}

class PeliculaDeTerror inherits Pelicula{
    var cucho
    override method recaudado() = super() + cucho*20000
}