import Text.Show.Functions

data Personaje = unPersonaje {
  nombre            ::String,
  poderBasico       ::PoderBasico,
  superPoder        ::SuperPoder,
  superPoderActivo  ::Bool,
  cantidadDeVida    ::Int
}deriving Show

type PoderBasico = Personaje -> Personaje
type SuperPoder = Personaje -> Personaje,

bolaEspinosa :: PoderBasico
bolaEspinosa unPersonaje = modificarVida (max 0 . subtract 1000) unPersonaje

modificarVida :: (Int -> Int) -> Personaje -> Personaje
modificarVida unaFuncion unPersonaje = unPersonaje { cantidadDeVida = unaFuncion . cantidadDeVida $ unPersonaje }

modificarNombre:: (String->String) -> Personaje -> Personaje
modificarNombre unaFuncion unPersonaje = unPersonaje{ nombre = unaFuncion . nombre $ unPersonaje}

espina :: Personaje
espina = UnPersonaje "Espina" bolaEspinosa "Granada de espinas" True 4800

lluviaDeTuercas:: String -> PoderBasico
lluviaDeTuercas "Sanadora" unPersonaje = modificarVida( + 800) unPersonaje
lluviaDeTuercas "Dañina" unPersonaje = modificarVida (`div` 2) unPersonaje
lluviaDeTuercas _ unPersonaje = unPersonaje

granadaDeEspinas:: Int -> PoderBasico
granadaDeEspinas radio unPersonaje 
  |radio>3 && cantidadDeVida unPersonaje<800 = unPersonaje{nombre = nombre unPersonaje + "Espina estuvo aqui",superPoderActivo = False ,cantidadDeVida = 0}
  |radio>3 modificarNombre (+"Espina Estuvo Aqui") unPersonaje
  |otherwise bolaEspinosa unPersonaje 

torretaCurativa:: PoderBasico
torretaCurativa unPersonaje = unPersonaje{superPoderActivo = True, cantidadDeVida unPersonaje *2}

atacarConPoderEspecial :: Personaje -> Personaje -> Personaje
atacarConPoderEspecial unPersonaje contrincante
  |superPoderActivo unPersonaje = superPoder unPersonaje
  |