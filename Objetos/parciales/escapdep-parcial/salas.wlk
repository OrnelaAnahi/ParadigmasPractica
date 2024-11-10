class Sala{
    const nombre 
    const dificultad
    var precioFijo = 10000
    method nombre()= nombre
    method precio()
    method esDificil() = dificultad > 7
}

class SalaDeAnime inherits Sala{
    override method precio() = precioFijo + 7000
}

class SalaDeHistoria inherits Sala{
    const esBasadaEnHechosReales = true
    override method precio() = precioFijo + dificultad * 0.314
    override method esDificil() = super() && not esBasadaEnHechosReales
}

class SalaDeTerror inherits Sala{
    var sustos
    override method precio(){
        if(sustos>5){
            return precioFijo + sustos * 0.2
        }else{
            return precioFijo
        }
    }
    override method esDificil() = super() || sustos > 5
}