module TierraDeBarbaros where
import Text.Show.Functions
import Data.Char (toUpper)
import Data.Char (isUpper)

    -- https://docs.google.com/document/d/1mBwfHLXmcZKLHSy22exTxibwny9x2a81hKW000tOFMQ/edit

data Barbaro = UnBarbaro {
    nombre :: Nombre,
    fuerza :: Fuerza,
    habilidades :: Habilidades,
    objetos :: Objetos
}
type Nombre = String
type Fuerza = Int
type Habilidad = String
type Habilidades = [Habilidad]
type Objeto = Barbaro -> Barbaro    
type Objetos = [Objeto]

dave = UnBarbaro{
    nombre="DAVE",
    fuerza = 100 ,
    habilidades =["tejer","escribirPoesia"],
    objetos = [ardilla, varitasDefectuosas]
}

--PUNTO 1
modificarFuerza :: (Fuerza->Fuerza)->Barbaro->Barbaro
modificarFuerza unaFuncion unBarbaro = unBarbaro {fuerza = unaFuncion.fuerza $ unBarbaro}
modificarNombre :: (Nombre->Nombre)->Barbaro->Barbaro
modificarNombre unaFuncion unBarbaro = unBarbaro {nombre = unaFuncion.nombre $ unBarbaro}
modificarHabilidades :: (Habilidades->Habilidades)->Barbaro->Barbaro
modificarHabilidades unaFuncion unBarbaro = unBarbaro {habilidades = unaFuncion.habilidades $ unBarbaro}
modificarObjetos :: (Objetos->Objetos)->Barbaro->Barbaro
modificarObjetos unaFuncion unBarbaro = unBarbaro {objetos = unaFuncion.objetos $ unBarbaro}
desaparecerObjetos unBarbaro = unBarbaro {objetos = [varitasDefectuosas]}

espadas:: Int -> Objeto
espadas pesoEspada = modificarFuerza (pesoEspada * 2 +) 

amuletosMisticas:: Habilidad -> Objeto
amuletosMisticas unaHabilidad unBarbaro = modificarHabilidades (++[unaHabilidad]) unBarbaro

varitasDefectuosas:: Objeto
varitasDefectuosas unBarbaro = modificarHabilidades (++["hacerMagia"]).desaparecerObjetos $ unBarbaro

ardilla :: Objeto
ardilla = id --toma un parametro y devuelve un parametro

cuerda::Objeto -> Objeto -> Objeto
cuerda = (.)

-- PUNTO 2
megafono unBarbaro = modificarHabilidades (concatenar.ponerEnMayuscula) unBarbaro

-- poner en mayuscula recibe una lista de habilidades es decir una lista de string y
-- devuelve una lista de string para que concatenar las una en una sola lista
ponerEnMayuscula :: [String]->[String]
ponerEnMayuscula unasHabilidades = map (map toUpper)  unasHabilidades

concatenar :: [String]->[String]
concatenar unasHabilidades = [concat unasHabilidades]

megafonoBarbarico :: Objeto
megafonoBarbarico = cuerda ardilla megafono

-- PUNTO 3

type Aventura = [Evento]
type Evento = Barbaro -> Bool

invasionDeSuciosDuende :: Evento
invasionDeSuciosDuende = tieneHabilidad "Escribir poesia Atroz" 

tieneHabilidad :: Habilidad -> Barbaro -> Bool
tieneHabilidad unaHabilidad unBarbaro =  (elem unaHabilidad . habilidades) unBarbaro

cremalleraDeTiempo :: Evento 
cremalleraDeTiempo unBarbaro = not.tienePulgares.nombre$unBarbaro

tienePulgares::Nombre -> Bool
tienePulgares "Faffy" = False
tienePulgares "Astro" = False
tienePulgares _ = True

ritualDeFechorias :: Evento
ritualDeFechorias unBarbaro = saqueo unBarbaro || gritoDeGuerra unBarbaro || caligrafia unBarbaro

saqueo :: Evento
saqueo unBarbaro = tieneHabilidad "robar" unBarbaro && fuerza unBarbaro > 80

gritoDeGuerra :: Evento 
gritoDeGuerra unBarbaro = poderGritoDeGuerra unBarbaro > poderNecesarioParaAprobar unBarbaro
poderGritoDeGuerra :: Barbaro -> Int
poderGritoDeGuerra unBarbaro = sum.map length.habilidades $ unBarbaro
    --opcion valida para mi poderGritoDeGuerra = length megafono 
poderNecesarioParaAprobar ::Barbaro -> Int
poderNecesarioParaAprobar unBarbaro = (*4).length.objetos$unBarbaro

caligrafia::Evento
caligrafia unBarbaro = all tieneMasDeTresVocalesyEmpiezaConMayuscula (habilidades unBarbaro)

tieneMasDeTresVocalesyEmpiezaConMayuscula::Habilidad->Bool
tieneMasDeTresVocalesyEmpiezaConMayuscula unaHabilidad = tieneMasDeTresVocales unaHabilidad && empiezaConMayuscula unaHabilidad

empiezaConMayuscula :: Habilidad -> Bool
empiezaConMayuscula = isUpper.head
tieneMasDeTresVocales :: Habilidad -> Bool
tieneMasDeTresVocales unaHabilidad = ((> 3).length. filter esVocal) unaHabilidad 
esVocal :: Char -> Bool
esVocal unCaracter = unCaracter `elem` "aeiouAEIOU"

sobrevivientes :: [Barbaro]->Aventura->[Barbaro]
sobrevivientes unosBarbaros unaAventura = filter (\unBarbaro -> all (\evento-> evento unBarbaro) unaAventura ) unosBarbaros

-- --PUNTO 4
-- eliminarRepetidos::(Eq a)=> [a]->[a]

-- eliminarRepetidos [] = []
-- eliminarRepetidos unElemento (cabeza:cola)
-- eliminarRepetidos _ (cabeza:cola) 
--   |elem cabeza cola = eliminarRepetidos cola
--   |otherwise = (cabeza:cola)


-- descendiente :: Barbaro -> Barbaro
-- descendiente  = utilizarObjetos.modificarNombre(++"*")
--     -- garro el primer elemento y reviso si ya esta en la lista lo puedo hacer sacandolo de la lista y haciendo un any con lo q queda de la lista 