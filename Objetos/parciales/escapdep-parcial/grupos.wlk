import escapistas.Escapistas
import salas.Sala
class Grupo{
    const escapistas = []

    method puedeSalirDe(unaSala){
        return escapistas.any({escapista=>escapista.puedeSalir(unaSala)})
    }

    method escaparDe(unaSala){
        self.pagar(unaSala)
        self.hacerEscapar(unaSala)
    }

    method pagar(unaSala){
        if(not self.puedenPagar(unaSala)){
            throw new Exception(message= "no pueden pagar la sala")
        }
        escapistas.forEach({escapista => escapista.pagar(self.montoAPagarPorEscapista(unaSala))})
    }

    method montoAPagarPorEscapista(unaSala){
        return unaSala.precio() / escapistas.size()
    }

    method puedenPagar(unaSala){
        return self.todosPuedenPagarLaSala(unaSala) || self.puedenCubrirElTotalDeLaSala(unaSala)
    }
    method todosPuedenPagarLaSala(unaSala){
        return escapistas.all({escapista => escapista.puedePagar(self.montoAPagarPorEscapista(unaSala))})
    }
    method puedenCubrirElTotalDeLaSala(unaSala){
        return self.dineroDeEscapistas() > unaSala.precio()
    }

    method dineroDeEscapistas(){
        return escapistas.sum({escapista=>escapista.saldoDeBilletera()})
    }

    method hacerEscapar(unaSala){
        escapistas.forEach({escapista => escapista.escapar(unaSala)})
    }

}