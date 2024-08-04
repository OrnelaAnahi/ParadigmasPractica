------------------------------------------------- CREAR DATA PARA LA CIUDAD ------------------------------------------------
import Text.Show.Functions

data Ciudad = UnaCiudad {
    nombre :: Nombre,
    anioDeFundacion :: AnioDeFundacion,
    atracciones :: Atracciones,
    costoDeVida :: CostoDeVida
} deriving Show

type Nombre = String
type AnioDeFundacion = Int
type Atraccion = String
type Atracciones = [Atraccion]
type CostoDeVida = Int

-------------------------------------------------- CIUDADES ------------------------------------------------------------------

baradero :: Ciudad
baradero = UnaCiudad {
  nombre = "Baradero", 
  anioDeFundacion = 1615, 
  atracciones = ["Parque del Este", "Museo Alejandro Barbich"],
  costoDeVida = 150
}

nullish :: Ciudad
nullish = UnaCiudad {
  nombre = "Nullish", 
  anioDeFundacion = 1800, 
  atracciones = [], 
  costoDeVida = 140
}

caletaOlivia :: Ciudad
caletaOlivia = UnaCiudad {
  nombre = "Caleta Olivia", 
  anioDeFundacion = 1901, 
  atracciones = [ "El Gorosito", "Faro Costanera"],
  costoDeVida = 120
}

maipu :: Ciudad
maipu = UnaCiudad {
  nombre = "Maipu", 
  anioDeFundacion = 1878,
  atracciones = ["Fortin Kakel"],
  costoDeVida = 115
  }

azul :: Ciudad
azul = UnaCiudad{
  nombre = "Azul", 
  anioDeFundacion = 1832, 
  atracciones = [ "Teatro espanol", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
  costoDeVida = 190
}

-------------------------------------------------- PUNTO 1 -----------------------------------------------------------------

noTieneAtracciones :: Ciudad -> Bool
noTieneAtracciones unaCiudad = null (atracciones unaCiudad)

valorDeCiudad :: Ciudad -> Int
valorDeCiudad unaCiudad 
  | esAntigua unaCiudad = 5 * (1800 - anioDeFundacion unaCiudad) 
  | otherwise = 3 * costoDeVida unaCiudad

esAntigua :: Ciudad -> Bool
esAntigua unaCiudad = anioDeFundacion unaCiudad < 1800

-------------------------------------------------- PUNTO 2 -----------------------------------------------------------------

------ Alguna Atraccion Copada
algunaAtraccionCopada :: Ciudad -> Bool
algunaAtraccionCopada unaCiudad = any esVocal.head $ (atracciones unaCiudad) 

esVocal :: Char -> Bool
esVocal unCaracter = unCaracter `elem` "aeiouAEIOU"

------ Ciudad Sobria 
esCiudadSobria :: Ciudad->Int->Bool
esCiudadSobria unaCiudad cantidadDeLetras = not (null (atracciones unaCiudad)) && all ((>cantidadDeLetras).length) (atracciones unaCiudad)

------ Tiene Nombre Raro
tieneNombreRaro :: Ciudad -> Bool
tieneNombreRaro unaCiudad = (<5).length $ nombre unaCiudad

-------------------------------------------------- PUNTO 3 -----------------------------------------------------------------

type Evento = Ciudad -> Ciudad

modificarCostoDeVida :: (Int ->  Int) -> Ciudad -> Ciudad
modificarCostoDeVida unaFuncion unaCiudad =  unaCiudad {costoDeVida = unaFuncion.costoDeVida $ unaCiudad}

modificarNombre :: (String->String) -> Ciudad -> Ciudad
modificarNombre unaFuncion unaCiudad = unaCiudad {nombre = unaFuncion.nombre $ unaCiudad}

-- modificar porcentualmente 
calcularCostoDeVidaPorcentual:: (Int -> Int -> Int) -> Int -> Int -> Int 
calcularCostoDeVidaPorcentual unaFuncion porcentaje costoDeVida =  (unaFuncion (costoDeVida * porcentaje  `div` 100)) $ costoDeVida

modificarCostoDeVidaPorcentual :: (Int->Int->Int) -> Int -> Ciudad -> Ciudad
modificarCostoDeVidaPorcentual unaFuncion unPorcentaje unaCiudad = modificarCostoDeVida (calcularCostoDeVidaPorcentual unaFuncion unPorcentaje) unaCiudad

------ Sumar una nueva atraccion
sumarUnaNuevaAtraccion :: Atraccion -> Evento
sumarUnaNuevaAtraccion unaAtraccion unaCiudad = (modificarCostoDeVidaPorcentual (+) 20).(modificarAtraccion ([unaAtraccion] ++)) $ unaCiudad

modificarAtraccion :: (Atracciones->Atracciones) -> Ciudad -> Ciudad
modificarAtraccion unaFuncion unaCiudad = unaCiudad {atracciones = unaFuncion.atracciones $ unaCiudad}

------ Crisis 
crisis :: Evento
crisis unaCiudad 
  | noTieneAtracciones unaCiudad =  modificarCostoDeVidaPorcentual subtract 10 unaCiudad
  | otherwise = (modificarCostoDeVidaPorcentual subtract 10).(modificarAtraccion (drop 1)) $ unaCiudad 

------ Remodelación
remodelacion :: Int -> Evento
remodelacion unPorcentaje unaCiudad =  (modificarCostoDeVidaPorcentual (+) unPorcentaje).modificarNombre ("New " ++) $ unaCiudad

---- Reevaluación 
reevaluacion :: Int -> Evento
reevaluacion cantidadDeLetras unaCiudad 
  | esCiudadSobria unaCiudad cantidadDeLetras = modificarCostoDeVidaPorcentual (+) 10 unaCiudad
  | otherwise = modificarCostoDeVida (subtract 3) unaCiudad 

-------------------------------------------------- PUNTO 4 -----------------------------------------------------------------

{- El comando sería el siguiente: sumarUnaNuevaAtraccion *atraccion*.remodelacion *porcentaje*. crisis. reevaluacion *numeroDeLetras* $ baradero
POR EJEMPLO: le queremos agregar a la ciudad Baradero un parque de diversiones, remoderarla con porcentaje 50%, causarle una crisis y reevaluarla tomando 5 letras.
el comando sería sumarUnaNuevaAtraccion "Parque de diversiones".remodelacion 50. crisis. reevaluacion 5 $ baradero -} 

-------------------------------------------------- ENTREGA 2  --------------------------------------------------------------------

-------------------------------------------------- PUNTO 1  --------------------------------------------------------------------

data Anio = UnAnio {
  numero :: Int,
  serieDeEventos :: [Evento]
} deriving (Show)

dosMilVeintiTres :: Anio
dosMilVeintiTres = UnAnio {
  numero = 2023,
  serieDeEventos = [crisis , sumarUnaNuevaAtraccion "parque" , remodelacion 10 , remodelacion 20]
}

dosmilVeintidos :: Anio
dosmilVeintidos = UnAnio 2022 [crisis, remodelacion 5, reevaluacion 7]

dosMilVeintiUno :: Anio
dosMilVeintiUno = UnAnio { 
  numero = 2021,
  serieDeEventos = [crisis, sumarUnaNuevaAtraccion "playa"]
}

dosmilQuince :: Anio
dosmilQuince = UnAnio 2015 []

pasoDeUnAnio :: Ciudad -> Anio -> Ciudad
pasoDeUnAnio unaCiudad unAnio = foldr ($) unaCiudad (serieDeEventos unAnio) -- ESTÁ BIEN, PERO COMO NUESTRA FUNCIÓN CRISIS SACA LA PRIMER ATRACCION, QUEDAN DISTINTO DE LA ESPERADO EN EL CASO DE PRUEBA

type Criterio = Ciudad->Int

algoMejor :: Ciudad -> Criterio -> Evento -> Bool
algoMejor unaCiudad unCriterio unEvento = unCriterio (unEvento unaCiudad) > unCriterio unaCiudad
--caso3 algoMejor azul (length.atracciones) (sumarUnaNuevaAtraccion "Monasterio Trapense") 

modificarEventosDeAnio :: ([Evento]->[Evento]) -> Anio -> Anio
modificarEventosDeAnio unaFuncion unAnio = unAnio {serieDeEventos= unaFuncion.serieDeEventos $ unAnio}

costoDeVidaQueSuba :: Ciudad -> Anio -> Ciudad
costoDeVidaQueSuba unaCiudad unAnio = aplicarEventosQueCumplan (algoMejor unaCiudad costoDeVida) unaCiudad unAnio 

costoDeVidaQueBaje :: Ciudad -> Anio -> Ciudad
costoDeVidaQueBaje unaCiudad unAnio = aplicarEventosQueCumplan (not.(algoMejor unaCiudad costoDeVida)) unaCiudad unAnio 

valorQueSuba :: Ciudad -> Anio -> Ciudad
valorQueSuba unaCiudad unAnio = aplicarEventosQueCumplan (algoMejor unaCiudad valorDeCiudad) unaCiudad unAnio 

type Condicion = Evento -> Bool

aplicarEventosQueCumplan :: Condicion -> Ciudad -> Anio -> Ciudad
aplicarEventosQueCumplan unaCondicion unaCiudad unAnio = pasoDeUnAnio unaCiudad (filtrarEventosQueCumplan unaCondicion unAnio)

filtrarEventosQueCumplan :: Condicion -> Anio -> Anio
filtrarEventosQueCumplan unaCondicion unAnio = (modificarEventosDeAnio (filter unaCondicion) unAnio)

----------------------------------------------- PUNTO 2 -------------------------------------------------------------------------

eventosOrdenados :: Anio -> Ciudad -> Bool
eventosOrdenados unAnio unaCiudad = serieDeEventosOrdenados (serieDeEventos unAnio) unaCiudad

serieDeEventosOrdenados :: Ciudad -> [Evento] -> Bool
serieDeEventosOrdenados unaCiudad [unEvento] = (costoDeVida.unEvento) unaCiudad > costoDeVida unaCiudad
serieDeEventosOrdenados  unaCiudad (cabeza:cola) = costoDeVida  ((head cola)unaCiudad) > costoDeVida (cabeza unaCiudad) && serieDeEventosOrdenados cola unaCiudad

ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool 
ciudadesOrdenadas unEvento [unaCiudad] = casoBase
ciudadesOrdenadas unEvento (cabeza:cola) =  ((costoDeVida.unEvento) (head cola))>((costoDeVida.unEvento) cabeza)  && (ciudadesOrdenadas unEvento cola)



{-serieDeEventosOrdenados :: Ciudad -> [Evento] -> Bool
serieDeEventosOrdenados unaCiudad [unEvento] = (costoDeVida.unEvento) unaCiudad > costoDeVida unaCiudad
serieDeEventosOrdenados  unaCiudad (cabeza:cola) = costoDeVida  ((head cola)unaCiudad) > costoDeVida.cabeza $ unaCiudad && serieDeEventosOrdenados cola unaCiudad

ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool 
ciudadesOrdenadas unEvento [unaCiudad] = casoBase unEvento unaCiudad
ciudadesOrdenadas unEvento (cabeza:cola) =  ((costoDeVida.unEvento.head & cola))>(costoDeVida.unEvento $cabeza)  && (ciudadesOrdenadas unEvento cola)
-}


criterioSerieDeEventos unaCiudad unEvento = costoDeVida.unEvento unaCiudad
criterioCiudadesOrdenadas unEvento unaCiudad = costoDeVida.unEvento unaCiudad  && (ciudadesOrdenadas unEvento cola)

recursividad:: (Ord a) => a -> [b] -> Bool
recursividad unElemento [unicaCiudad] _ = (costoDeVida.unEvento) unaCiudad > costoDeVida unaCiudad
recursividad unElemento (cabeza:cola) criterio = criterio unElemento (head cola) > criterio unElemento cabeza  && (recursividad unElemento cola)

aniosOrdenados :: [Anio] -> Ciudad -> Bool 
aniosOrdenados [unAnio] unaCiudad = (costoDeVidaPorPasoDeUnAnio unAnio unaCiudad) > costoDeVida unaCiudad
aniosOrdenados (cabeza : cola) unaCiudad =  (costoDeVidaPorPasoDeUnAnio (head cola) unaCiudad ) > (costoDeVidaPorPasoDeUnAnio cabeza unaCiudad )  && (aniosOrdenados cola unaCiudad)

costoDeVidaPorPasoDeUnAnio :: Anio -> Ciudad -> Int
costoDeVidaPorPasoDeUnAnio unAnio unaCiudad = costoDeVida $ pasoDeUnAnio unaCiudad unAnio 

----------------------------------------------- PUNTO 3 -------------------------------------------------------------------------

historiaSinFin :: [Anio]
historiaSinFin = [dosMilVeintiUno, dosmilVeintidos] ++ repeat dosMilVeintiTres