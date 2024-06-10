module Vacaciones where
import Text.Show.Functions

data Turista = UnTurista {
  cansancio       ::Cansancio,
  stress          ::Stress,
  viajaSolo       ::Bool,
  idiomas         :: Idiomas
}deriving Show

type Cansancio = Int
type Stress = Int
type Idiomas = [Idioma]
type Idioma = String    

type Excursion = Turista -> Turista


----------EJEMPLOS
ana :: Turista
ana =
  UnTurista { cansancio = 0 , stress = 21, viajaSolo = False, idiomas = ["espaniol"] }

beto :: Turista
beto =
  UnTurista { cansancio = 15, stress = 15, viajaSolo = True, idiomas = ["aleman"] }

cathi :: Turista
cathi =
  UnTurista { cansancio = 15, stress = 15, viajaSolo = True, idiomas = ["aleman", "catalan"] }

modificarCansancio :: (Cansancio -> Cansancio) -> Turista -> Turista
modificarCansancio unaFuncion unTurista = unTurista {cansancio = unaFuncion.cansancio$unTurista}
modificarStress :: (Stress -> Stress) -> Turista -> Turista
modificarStress unaFuncion unTurista = unTurista {stress = unaFuncion.stress$unTurista}
modificarIdiomas :: (Idiomas -> Idiomas) -> Turista -> Turista
modificarIdiomas unaFuncion unTurista = unTurista {idiomas = unaFuncion.idiomas$unTurista}
acompaniado :: Turista -> Turista
acompaniado unTurista = unTurista {viajaSolo = False}


irALaPlaya :: Excursion
irALaPlaya unTurista
  |viajaSolo unTurista = modificarCansancio (subtract 5) unTurista
  |otherwise = modificarStress (subtract 1) unTurista

apreciarUn :: String -> Excursion
apreciarUn elementoDelPaisaje = modificarStress (subtract (length elementoDelPaisaje))

salirAHablar :: Idioma -> Excursion
salirAHablar unIdioma = acompaniado.modificarIdiomas(++[unIdioma])

caminar :: Int -> Excursion
caminar tiempo  = modificarCansancio (+ (intensidad tiempo)). modificarStress(subtract(intensidad tiempo))

intensidad :: Int -> Int
intensidad minutos= minutos `div` 4
data Marea
  = Tranquila
  | Moderada
  | Fuerte

paseoEnBarco :: Marea -> Excursion
paseoEnBarco Fuerte = modificarStress(+6).modificarCansancio(+10)
paseoEnBarco Tranquila = caminar 10 . apreciarUn "mar" . salirAHablar "aleman"
paseoEnBarco Moderada = id

-------------------
{-

Modelar las excursiones anteriores de forma tal que para agregar una excursión al sistema no haga falta modificar las funciones existentes. Además:
Hacer que un turista haga una excursión. Al hacer una excursión, el turista además de sufrir los efectos propios de la excursión, reduce en un 10% su stress.


-}
-- modificar porcentualmente 
-- calcularCostoDeVidaPorcentual:: (Int -> Int -> Int) -> Int -> Int -> Int 
-- calcularCostoDeVidaPorcentual unaFuncion porcentaje costoDeVida =  (unaFuncion (costoDeVida * porcentaje  `div` 100)) $ costoDeVida

-- modificarCostoDeVidaPorcentual :: (Int->Int->Int) -> Int -> Ciudad -> Ciudad
-- modificarCostoDeVidaPorcentual unaFuncion unPorcentaje unaCiudad = modificarCostoDeVida (calcularCostoDeVidaPorcentual unaFuncion unPorcentaje) unaCiudad


modificarStressPorcentual :: (Int ->Int->Int)->Int->Turista->Turista
modificarStressPorcentual unaFuncion unPorciento unTurista = unTurista { stress = unaFuncion ((stress unTurista) * unPorciento `div` 100). stress $ unTurista}

-- hacerExcursion :: Excursion -> Turista -> Turista
-- hacerExcursion unaExcursion = unaExcursion.modificarStressPorcentual (+) 10
-- calcularStressPorcentual :: (Int -> Int -> Int) -> Int -> Int -> Int 
-- calcularStressPorcentual unaFuncion unPorcentaje cantidadStress = (unaFuncion (cantidadDeStress * unPorcentaje `div` 100)) $ cantidadStress

-- modificarStressPorcentual ::(Int->Int->Int) -> Int -> Turista -> Turista
-- modificarStressPorcentual unaFuncion unPorciento unTurista = 
--     unTurista { stress = unaFuncion ((stress unTurista) * unPorciento `div` 100) . stress $ unTurista }

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion unaExcursion = unaExcursion . modificarStressPorcentual (subtract) 10 


deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

type Indice = (Turista->Int)

deltaExcursionesSegun :: Indice ->  Turista -> Excursion ->Int
deltaExcursionesSegun indice unTurista unaExcursion   = deltaSegun indice (hacerExcursion unaExcursion unTurista) unTurista 
    -- abs . subtract (indice unTurista) . indice . unaExcursion $ unTurista
    -- abs ((indice unTurista) - (indice (unaExcursion unTurista)))
esEducativa ::  Turista -> Excursion ->Bool
esEducativa unTurista  = (> 0).deltaExcursionesSegun (length.idiomas) unTurista

excursionesDesestresantes :: Turista -> [Excursion]->[Excursion]
excursionesDesestresantes unTurista unasExcursiones = filter (esDesestresante unTurista) unasExcursiones

esDesestresante :: Turista -> Excursion ->Bool
esDesestresante unTurista = (<= -3).deltaExcursionesSegun (stress) unTurista

type Tour = [Excursion]


completo :: Tour
completo = [caminar 20, apreciarUn "cascada", caminar 40, irALaPlaya, salidaLocal]

ladoB :: Excursion -> Tour
ladoB excursion = [paseoEnBarco Tranquila, excursion, caminar 120]

islaVecina :: Marea -> Tour
islaVecina mareaVecina = [paseoEnBarco mareaVecina, excursionEnIslaVecina mareaVecina, paseoEnBarco mareaVecina]

excursionEnIslaVecina :: Marea -> Excursion
excursionEnIslaVecina Fuerte = apreciarUn "lago"
excursionEnIslaVecina _  = irALaPlaya

salidaLocal :: Excursion
salidaLocal = salirAHablar "melmacquiano"

-----------------a
hacerUnTour ::  Turista -> Tour ->Turista
hacerUnTour unTurista unTour = foldl (flip hacerExcursion) (modificarStress (subtract (length unTour)) unTurista) unTour

-- hayTourConvicente :: [Tour]->Turista -> Bool
-- hayTourConvicente unosTours unTurista = any (esConvicente unTurista) unosTours

propuestaConvincente :: Turista -> [Tour] -> Bool
propuestaConvincente turista = any (esConvincente turista)


-- esConvicente :: Turista -> Tour -> Bool
-- esConvicente unTurista unTour = any (\excursion -> esDesestresante unTurista excursion && dejaAcompaniado unTurista excursion ) unTour

-- dejaAcompaniado :: Turista -> Excursion ->Bool
-- dejaAcompaniado unTurista unaExcursion = (not.viajaSolo. hacerExcursion unaExcursion) unTurista

esConvincente :: Turista -> Tour -> Bool
esConvincente turista = any (dejaAcompaniado turista) . excursionesDesestresantes turista

dejaAcompaniado :: Turista -> Excursion -> Bool
dejaAcompaniado turista = not . viajaSolo . flip hacerExcursion turista


-- saberSiHayTourConvincente :: [Tour]->Turista -> Bool
-- saberSiHayTourConvincente unosTour unTurista = any (esConvicente unTurista) unosTour

-- esConvicente :: Turista ->Tour -> Bool
-- esConvicente unTurista  = any (dejaAcompaniado unTurista). excursionesDesestresantes unTurista 

-- dejaAcompaniado :: Turista -> Excursion -> Bool
efectividad ::Tour -> [Turista] -> Int
efectividad unTour  =  sum . map (espiritualidadAportada unTour) . filter (flip esConvincente unTour) 

espiritualidadAportada :: Tour -> Turista -> Int
espiritualidadAportada tour turista = negate. deltaRutina tour turista

deltaRutina :: Tour -> Turista -> Int
deltaRutina tour turista = deltaSegun nivelDeRutina (hacerUnTour turista tour) turista

nivelDeRutina :: Turista -> Int
nivelDeRutina turista = cansancio turista + stress turista