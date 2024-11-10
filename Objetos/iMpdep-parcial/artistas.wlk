class Artista{
    var experiencia
    var peliculasFilmadas
    var ahorros
    method sueldo() = experiencia.sueldo(self.nivelDeFama())
    method nivelDeFama()= peliculasFilmadas/2

    method recategorizarExperiencia(){
        experiencia.recategorizar(self,self.nivelDeFama())
    }
    method cambiarExperiencia(unaExperiencia){
        experiencia = unaExperiencia
    }
    method actuar(){
        peliculasFilmadas +=1
        ahorros += self.sueldo()
    }

}

object amateur{
    method sueldo(nivelDeFama) = 10000
    method recategorizar(artista,nivelDeFama){
        if(nivelDeFama*2>10){
            artista.cambiarExperiencia(establecida)
        }
    }
}

object establecida{
    method sueldo(nivelDeFama){
        if(nivelDeFama<15){
            return 15000
        }else{
            return nivelDeFama*5000
        } 
    }
    method recategorizar(artista,nivelDeFama){
        if(nivelDeFama>10){
            artista.cambiarExperiencia(estrella)
        }
    }
}

object estrella{
    method sueldo(nivelDeFama)= nivelDeFama*2*30000
    method recategorizar(artista,nivelDeFama){
        throw new Exception(message="No puede recategorizarse, es una estrella")
    }
}
