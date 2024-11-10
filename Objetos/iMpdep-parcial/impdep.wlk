class IMPdeP{
    const artistas = #{}
    const peliculas = #{}

    method artistaMejorPago(){
        return artistas.max({artista=>artista.sueldo()})
    }

    method peliculasEconomicas(){
        return peliculas.filter({pelicula=>peliculas.presupuesto()<500000})
    }

    method nombreDePeliculasEconomicas() = self.peliculasEconomicas().map({pelicula=>pelicula.nombre()})
    
    method sumaDeGananciaDePeliculasEconomicas()= self.peliculasEconomicas().sum({pelicula=>pelicula.presupuesto()})

    method recategorizarArtistas(){
        artistas.forEach({artista=>artista.recategorizarExperiencia()})
    }
}