import salas.Sala

class Escapista{
    var maestria
    const salasSalidas = []
    var saldoDeBilletera 

    method puedeSalirDe(unaSala){
        return maestria.puedeSalir(unaSala,self)
    }
    method hizoMuchasSalas(){
        return salasSalidas.size()>=6
    }
    method subirMaestria(){
        if(self.es(profesional)){
            throw new Exception(message="No se puede ser mas que profesional")
        }
        if(self.hizoMuchasSalas()){
            maestria = profesional
        }
    }

    method es(unaMaestria) = maestria == unaMaestria
    method nombreDeSalasDeLasQueSalio(){

        return self.salasDeLasQueSalioSinRepetir().map({sala => sala.nombre()})
    }
    method salasDeLasQueSalioSinRepetir(){
        return salasSalidas.asSet()
    }

    method escapar(unaSala){
        salasSalidas.add(unaSala)
    }

    method pagar(unMonto){
        saldoDeBilletera -= unMonto
    }

    method puedePagar(unMonto){
        return saldoDeBilletera > unMonto
    }
    method saldoDeBilletera() = saldoDeBilletera 
}

object amateur{
    method puedeSalir(unaSala,unEscapista){
        return not (unaSala.esDificil()) && unEscapista.hizoMuchasSalas()
    }
}

object profesional{
    
    method puedeSalir(unaSala,unEscapista) = true
}