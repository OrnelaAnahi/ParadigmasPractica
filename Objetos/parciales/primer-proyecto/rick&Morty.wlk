class Rick{
    var nivelDeDemencia
    // acompaniante
    method modificarNivelDeDemencia(unNum){
        nivelDeDemencia += unNum
    }
}
class Morty{
    var saludMental 
    method irseDeAventuraCon(unRick){
        saludMental -= 20
        unRick.modificarNivelDeDemencia(50)
    }
}
class Beth{
    var afectoPorPadre
    method irseDeAventuraCon(unRick){
        afectoPorPadre += 10
        unRick.modificarNivelDeDemencia(-20)
    }
}
// class Summer{
//  irseDeAventuraCon(unRick)
// }

// object jerry{
//  irseDeAventuraCon(unRick)
// }
// interface Acompaniante{
//  irseDeAventuraCon(unRick)
// }