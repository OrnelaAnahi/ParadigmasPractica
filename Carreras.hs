module Carreras where
import Text.Show.Functions

-- https://docs.google.com/document/d/1g2Gc81R62_xAIiGF0H663ypAz1vxJybr5LDo1sj9tAU/edit#heading=h.ielqgky5ojzp

type Color = String
type Velocidad = Int
type Distancia = Int

data Auto = UnAuto {
  color                     :: Color,
  velocidad                 :: Velocidad,
  distanciaRecorrida        :: Distancia
}deriving (Eq, Show)

autoRojo = UnAuto { color = "rojo", velocidad = 100, distanciaRecorrida = 20}
autoVerde = UnAuto { color= "Verde",velocidad = 100,distanciaRecorrida =150}
autoAzul = UnAuto { color= "Azul",velocidad = 100,distanciaRecorrida =15}
carreraUno = [autoRojo, autoVerde, autoAzul]
-- modificarNombre unAuto = 


type Carrera = [Auto]
type Puesto = Int

estanCerca :: Auto -> Auto -> Bool
estanCerca unAuto otroAuto = unAuto /= otroAuto && distanciaEntre unAuto otroAuto <10

distanciaEntre :: Auto -> Auto -> Distancia
distanciaEntre unAuto otroAuto = abs . (distanciaRecorrida unAuto -). distanciaRecorrida$ otroAuto


tieneAlgunAutoCerca :: Auto -> Carrera -> Bool 
tieneAlgunAutoCerca auto = any (estanCerca auto) 

vaGanando :: Auto -> Carrera -> Bool
vaGanando unAuto= all  (vaAdelante unAuto). filter (/= unAuto)

vaAdelante :: Auto -> Auto -> Bool
vaAdelante unAuto otroAuto = distanciaRecorrida unAuto > distanciaRecorrida otroAuto

vaAtras :: Auto -> Auto -> Bool
vaAtras unAuto otroAuto = distanciaRecorrida unAuto < distanciaRecorrida otroAuto


andaTranquilo::Auto -> Carrera -> Bool
andaTranquilo unAuto unaCarrera = (not.tieneAlgunAutoCerca unAuto) unaCarrera && vaGanando unAuto unaCarrera

puestoDe ::Auto ->Carrera ->Puesto
puestoDe unAuto = (1 + ).length.filter(vaAtras unAuto) 
-- puestoDe unAuto unaCarrera = (1 + ).length.filter(not.vaAdelante unAuto) $ unaCarrera
-- puestoDe unAuto = (1 + ).length.listaDeAdelantados unAuto

-- listaDeAdelantados::Auto->Carrera->Carrera
-- listaDeAdelantados unAuto =  filter(not.vaAdelante unAuto) unaCarrera

----------------PUNTO 2----------------------------

type Tiempo  = Int

-- modificarDistancia :: (Distancia ->Distancia)->Auto->Auto
-- modificarDistancia unaFuncion unAuto = unAuto{distanciaRecorrida = unaFuncion.distanciaRecorrida$unAuto}

-- correr :: Tiempo -> Auto -> Auto
-- correr unTiempo unAuto = modificarDistancia ((+).(unTiempo*).velocidad$unAuto) unAuto

correr :: Tiempo -> Auto -> Auto
correr unTiempo unAuto = unAuto{distanciaRecorrida =unTiempo * velocidad unAuto + distanciaRecorrida unAuto}

modificarVelocidad :: (Velocidad->Velocidad)-> Auto -> Auto
modificarVelocidad modificador unAuto = unAuto { velocidad = max 0.modificador.velocidad$unAuto}

bajarVelocidad :: Int -> Auto -> Auto 
bajarVelocidad unaCantidad  = modificarVelocidad (subtract unaCantidad) 


type PowerUps = Auto -> Carrera -> Carrera

terremoto :: PowerUps
terremoto autoGatillador unaCarrera = afectarALosQueCumplen (estanCerca autoGatillador) (bajarVelocidad 50) unaCarrera

miguelitos :: Int -> PowerUps
miguelitos velocidadABajar autoGatillador unaCarrera = afectarALosQueCumplen (vaAdelante autoGatillador) (bajarVelocidad velocidadABajar) unaCarrera

jetPack :: Int -> PowerUps
jetPack tiempoDeImpacto autoGatillador unaCarrera = afectarALosQueCumplen (== autoGatillador) (modificarVelocidad (\ _ -> velocidad autoGatillador) . correr tiempoDeImpacto . modificarVelocidad (*2)) unaCarrera
-- (modificarVelocidad (\ _ ->velocidad autoGatillador.correr tiempoDeImpacto.modificarVelocidad (*2))  )

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a] 
afectarALosQueCumplen criterio efecto lista = (map efecto . filter criterio) lista ++ filter (not.criterio) lista

-----------PUNTO 4 ------------------
type Evento = Carrera -> Carrera
type Eventos = [Evento]

simularCarrera :: Carrera -> Eventos -> [(Puesto,Color)]
simularCarrera unaCarrera unaListaDeEventos = armarTablaDePosiciones.procesarEventos unaListaDeEventos $ unaCarrera

procesarEventos :: Eventos -> Carrera -> Carrera
procesarEventos unaListaDeEventos carreraInicial = foldl (\carreraActual evento -> evento carreraActual) carreraInicial unaListaDeEventos

armarTablaDePosiciones :: Carrera -> [(Puesto,Color)]
armarTablaDePosiciones unaCarrera = map (entradaDeTabla unaCarrera) unaCarrera

entradaDeTabla :: Carrera -> Auto -> (Puesto,Color)
entradaDeTabla unaCarrera unAuto = (puestoDe unAuto unaCarrera, color unAuto)

correnTodos :: Tiempo -> Evento
correnTodos unTiempo = map (correr unTiempo)

-- usaPowerUp :: PowerUps -> Evento
-- usaPowerUp = unPowerUp  RARIIIIIIIIIIII

