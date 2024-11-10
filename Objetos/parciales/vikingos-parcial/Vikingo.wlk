class Vikingo{
    var castaSocial
    
    method esProductivo()

    method puedeSubirAExpedicion(){
        return self.esProductivo() && castaSocial.permiteCastaSubir(self)
    }

    method tieneArmas()
}

class Soldado inherits Vikingo{
    var vidasCobradas
    var cantidadDeArmas

    override method esProductivo(){
        return vidasCobradas >20 && self.tieneArmas()
    }

    override method tieneArmas() =  cantidadDeArmas>0
}
class Granjero inherits Vikingo{
    var cantidadDeHijos
    var hectareasDesignadas

    override method esProductivo(){
        return hectareasDesignadas > 2* cantidadDeHijos
    }
    override method tieneArmas() = false


}

object jarl{
    method permiteCastaSubir(vikingo) = not(vikingo.tieneArmas())
}

object karl inherits Casta {

}

object thrall inherits Casta {

}

class Casta {
	method puedeIr(vikingo,expedicion) = true
}