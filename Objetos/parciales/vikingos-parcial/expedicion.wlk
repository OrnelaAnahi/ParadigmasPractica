class NoPuedeSubirAExpedicionException inherits Exception {}

class Expedicion{
    const objetivos = []
    const vikingos = #{}

    method subirAExpedicion(unVikingo){
        if(not unVikingo.puedeSubirAExpedicion()){
            throw new NoPuedeSubirAExpedicionException(message = " no se puede subir a expedicion un vikingo")
        }
        vikingos.add(unVikingo)
    }


    method cantidadDeVikingos()= vikingos.size()

    method valeLaPena(){
        return objetivos.all({objetivo => objetivo.valeLaPena(self.cantidadDeVikingos())})
    }
    method realizarExpedicion(){ 
        self.invadirObjetivos()
        self.dividirBotinDeOro()
    }
    method invadirObjetivos(){
        objetivos.forEach({objetivo=>objetivo.serInvadidoPor(self)})
    }
    method dividirBotinDeOro(){

    }
    unaExpedicion.cobrarVida(unaCiudad){
        
    }
}




class Capital{
    // var botin
    const factorDeRiqueza
    var defensores

    method valeLaPena(cantidadDeVikingos) = self.botin(cantidadDeVikingos) > 3*cantidadDeVikingos

    method botin(cantidadDeVikingos){
        return self.defensoresDerrotados(cantidadDeVikingos) * factorDeRiqueza
    }

    method defensoresDerrotados(cantDeVikingos){
        return defensores.min(cantDeVikingos)
    }

    method serInvadidoPor(unaExpedicion){
        unaExpedicion.cobrarVida(self)
    }

}

class Aldea {
    var crucifijos
    method botin() = crucifijos
    method valeLaPena() = self.botin()> 15
}
