module Samurai where
import Text.Show.Functions
-- https://docs.google.com/document/d/1mhQ2R8VjpoVrQ5JroYbkiBHjZME9gw6jEn6OI2q6Q2U/edit

data Elemento = UnElemento { 
  tipo :: String,
  ataque :: (Personaje-> Personaje),
  defensa :: (Personaje-> Personaje) 
}
data Personaje = UnPersonaje {
  nombre :: String,
  salud :: Float,
  elementos :: [Elemento],
  anioPresente :: Int 
}

-----------------PUNTO 1
mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio unAnio unPersonaje = unPersonaje {anioPresente = unAnio}

modificarSalud :: (Float->Float)->Personaje->Personaje
modificarSalud unaFuncion unPersonaje = unPersonaje {salud = max 0.unaFuncion.salud$unPersonaje}

meditar::Personaje->Personaje
meditar unPersonaje = modificarSalud (*1.5) unPersonaje

causarDanio :: Float -> Personaje ->Personaje
causarDanio cantidadABajar unPersonaje = modificarSalud (subtract cantidadABajar) unPersonaje


-------------------PUNTO 2
esMalvado :: Personaje -> Bool
esMalvado unPersonaje = any (esDeTipo "Maldad") . elementos $ unPersonaje

esDeTipo :: String ->Elemento->Bool
esDeTipo unTipo unElemento = tipo unElemento == unTipo

danioQueProduce :: Personaje ->Elemento->Float
danioQueProduce unPersonaje unElemento = ((salud unPersonaje -) . salud . ataque unElemento) unPersonaje 
-- danioQueProduce unPersonaje unElemento = salud unPersonaje - salud (ataque unElemento unPersonaje)

type Enemigos = [Personaje]

enemigosMortales:: Personaje -> Enemigos -> Enemigos
enemigosMortales unPersonaje unosEnemigos = filter (esEnemigoMortal unPersonaje) unosEnemigos

esEnemigoMortal :: Personaje ->Personaje->Bool
esEnemigoMortal unPersonaje unEnemigo = (any (esAtaqueMortal unPersonaje). elementos ) unEnemigo

esAtaqueMortal :: Personaje -> Elemento -> Bool
esAtaqueMortal unPersonaje unElemento= salud unPersonaje  == danioQueProduce unPersonaje unElemento

concentracion :: Int -> Elemento
concentracion unNivel = UnElemento {
  tipo = "Magia",
  ataque = noHacerNada,
  defensa = aplicarMeditar unNivel 
}
noHacerNada = id
aplicarMeditar unNivel = foldr1 (.) (replicate unNivel meditar)
-- meditar 3 = meditar.meditar.meditar

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados unaCantidad = replicate unaCantidad esbirros

esbirros :: Elemento
esbirros = UnElemento {
    tipo = "Maldad",
    ataque = causarDanio 1,
    defensa = noHacerNada
}

katanaMagica :: Elemento
katanaMagica = UnElemento "Magia" (causarDanio 100) noHacerNada

jack :: Personaje
jack = UnPersonaje {
    nombre ="Jack",
    salud = 300,
    elementos = [concentracion 3, katanaMagica],
    anioPresente = 200
}

aku:: Int->Float ->Personaje
aku unAnio cantidadDeSalud = UnPersonaje {
  nombre = "Aku",
  salud = cantidadDeSalud,
  anioPresente =unAnio,
  elementos = concentracion 4 : portalAlFuturoDesde unAnio : esbirrosMalvados (unAnio*100) 
}

portalAlFuturoDesde unAnio = UnElemento {
    tipo = "Magia",
    ataque = mandarAlAnio (unAnio + 2800),
    defensa = aku (unAnio + 2800).salud
}

luchar :: Personaje -> Personaje -> (Personaje,Personaje)
luchar atacante defensor 
  |estaMuerto atacante = (defensor, atacante)
  |otherwise = luchar (aplicarAtaques atacante defensor) (aplicarDefensas atacante)

estaMuerto = ((==0).salud)


aplicarAtaques unAtacante unDefensor = aplicarElementos ataque (elementos unAtacante) unDefensor
aplicarDefensas unAtacante = aplicarElementos defensa (elementos unAtacante) unAtacante

aplicarElementos :: (Elemento -> Personaje -> Personaje) -> [Elemento] -> Personaje -> Personaje
-- map funcion elementos me arma una lista con la funcion de elemenentos puede ser en este caso ataque o defensa 
aplicarElementos funcion elementos personaje = foldl afectar personaje (map funcion elementos)

-- afectar :: Personaje -> (Personaje -> Personaje) ->Personaje CREO
afectar personaje unAtaqueODefensa = unAtaqueODefensa personaje

-- foldr(\unElemento acumulador ->)

-- map devuelve una lista de algo

f :: (Eq t1, Num t2) =>(t1 -> a1 -> (a2, a2)) -> (t2 -> t1) -> t1 -> [a1] -> [a2]
f x y z
  | y 0 == z = map (fst.x z)
  | otherwise = map (snd.x (y 0))

