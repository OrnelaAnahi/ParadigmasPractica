module MiniGolfito where
import Text.Show.Functions
-- https://docs.google.com/document/d/1LeWBI6pg_7uNFN_yzS2DVuVHvD0M6PTlG1yK0lCvQVE/edit#heading=h.wn9wma8e1ale

-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


type Palo = Habilidad -> Tiro

putter :: Palo
putter unaHabilidad= UnTiro {
  velocidad = 10,
  precision = ((*2).precisionJugador) unaHabilidad,
  altura = 0 
}

madera::Palo
madera unaHabilidad = UnTiro {
  velocidad = 100,
  precision = precisionJugador unaHabilidad `div` 2,
  altura = 5
}

hierro :: Int -> Palo
hierro unNumero unaHabilidad = UnTiro {
  velocidad =(*unNumero).fuerzaJugador$unaHabilidad,
  precision = precisionJugador unaHabilidad `div` unNumero,
  altura = max 0 (unNumero-3)
}

palos:: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

-----------PUNTO2
golpe :: Jugador -> Palo ->Tiro
golpe unJugador unPalo = unPalo.habilidad$ unJugador


golpe' ::  Palo -> Jugador ->Tiro
golpe' unPalo = unPalo.habilidad

tiroDetenido :: Tiro
tiroDetenido = UnTiro 0 0 0
-------------Punto 3


modificarVelocidad :: (Int -> Int) -> Tiro -> Tiro
modificarVelocidad unaFuncion unTiro = unTiro {velocidad = unaFuncion.velocidad$unTiro }
modificarAltura :: (Int -> Int) -> Tiro -> Tiro
modificarAltura unaFuncion unTiro = unTiro {altura = unaFuncion.altura$unTiro}
modificarPrecision:: (Int -> Int) -> Tiro -> Tiro
modificarPrecision unaFuncion unTiro = unTiro {precision = unaFuncion.precision$unTiro }



data Obstaculo = UnObstaculo {
  puedeSuperar :: Tiro -> Bool,
  efectoLuegoDeSuperar :: Tiro -> Tiro
}

-----------------------------a-----------------------
tunelConRampita::Obstaculo
tunelConRampita  = UnObstaculo superaRampita efectoTunelRampita

efectoTunelRampita :: Tiro -> Tiro
efectoTunelRampita unTiro = modificarVelocidad(*2).modificarPrecision(const 100).modificarAltura(const 0) $ unTiro

superaRampita :: Tiro -> Bool
superaRampita unTiro = precision unTiro > 90 && vaAlRas unTiro

vaAlRas :: Tiro -> Bool
vaAlRas = (==0).altura

----------------------------------b----------------------------

laguna :: Int -> Obstaculo
laguna unLargo = UnObstaculo superaLaguna (efectoLaguna unLargo)

superaLaguna :: Tiro -> Bool
superaLaguna unTiro = velocidad unTiro > 80 &&  (between 1 5 . altura) unTiro

efectoLaguna :: Int ->  Tiro -> Tiro 
efectoLaguna unLargo unTiro  = modificarAltura(`div` unLargo) unTiro
-- efectoLaguna unLargo  = modificarAltura (\altura -> altura `div` unLargo) 

---------------------------------C-------------------------
hoyo :: Obstaculo
hoyo = UnObstaculo superaHoyo efectoHoyo

efectoHoyo :: Tiro -> Tiro
efectoHoyo _ = tiroDetenido

superaHoyo :: Tiro -> Bool
superaHoyo unTiro = (between 5 20 . velocidad) unTiro && precision unTiro > 95 && vaAlRas unTiro


------------------PUNTO 4 --------------

palosUtiles::Jugador->Obstaculo->[Palo]
palosUtiles unJugador unObstaculo = filter (puedeSuperar unObstaculo . golpe unJugador) palos

palosUtiles' unJugador unObstaculo = filter (leSirveParaSuperar unObstaculo unJugador) palos
leSirveParaSuperar unObstaculo unJugador = puedeSuperar unObstaculo . golpe unJugador 

-- cuantosObstaculosConsecutivosPuedeSuperar:: [Obstaculo] -> Tiro -> Int
-- cuantosObstaculosConsecutivosPuedeSuperar [] unTiro = 0 
-- cuantosObstaculosConsecutivosPuedeSuperar (head:cola) unTiro 
--   |puedeSuperar head unTiro = 1 + cuantosObstaculosConsecutivosPuedeSuperar cola (efectoLuegoDeSuperar head unTiro)
--   |otherwise = 0

cuantosObstaculosConsecutivosSupera :: Tiro -> [Obstaculo] -> Int
cuantosObstaculosConsecutivosSupera tiro [] = 0
cuantosObstaculosConsecutivosSupera tiro (obstaculo : obstaculos)
  | puedeSuperar obstaculo tiro = 1 + cuantosObstaculosConsecutivosSupera (efectoLuegoDeSuperar obstaculo tiro) obstaculos
  | otherwise = 0


paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip cuantosObstaculosConsecutivosSupera obstaculos.golpe jugador) palos

-- paloMasUtil :: Jugador -> [Obstaculo] -> [Palo] -> Palo
-- paloMasUtil unJugador unosObstaculos =
--   maximoSegun (\palo -> cuantosObstaculosConsecutivosPuedeSuperar unosObstaculos (golpe unJugador palo)) palos


jugadorDeTorneo = fst
puntosGanados = snd

padresQuePierden :: [(Jugador, Puntos)] -> [String]
padresQuePierden listaDeResultados = (map (padre.jugadorDeTorneo).filter(not. gano listaDeResultados))listaDeResultados

gano ::  [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano listaDeResultados puntoDeUnJugador = ( all (\unResultado -> puntosGanados puntoDeUnJugador > puntosGanados unResultado) . filter  (/= puntoDeUnJugador) )listaDeResultados