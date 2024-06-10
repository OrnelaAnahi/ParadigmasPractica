module Huber where
import Text.Show.Functions

data Chofer = UnChofer{
  nombre :: Nombre,
  kilometrajeDeAuto :: Int,
  viajes :: [Viaje],
  condicion :: Condicion
}deriving Show

data Viaje = UnViaje {
  fecha :: (Int,Int,Int),
  cliente :: Cliente,
  costo :: Int
}deriving Show

type Nombre = String
type Direccion = String
type Cliente = (Nombre, Direccion)
type Condicion = Viaje -> Bool

obtenerNombre = fst
obtenerDireccion = snd

tomarCualquierViaje :: Condicion
tomarCualquierViaje _ = True

tomarViajeConCostoMayor :: Condicion
tomarViajeConCostoMayor = (>200).costo

tomarViajeConNombre :: Int -> Condicion
tomarViajeConNombre cantidadDeLetras = (>cantidadDeLetras).length.obtenerNombre.cliente 

tomarViajeSiNoVive :: Direccion -> Condicion
tomarViajeSiNoVive unaZona = (/= unaZona).obtenerDireccion.cliente 

lucas :: Cliente
lucas = ("Lucas", "Victoria")

daniel::Chofer
daniel = UnChofer{
  nombre = "Daniel",
  kilometrajeDeAuto = 23500,
  viajes = [UnViaje (20,04,2017) lucas 150],
  condicion = tomarViajeSiNoVive "Olivos"
}
alejandra::Chofer
alejandra = UnChofer{
  nombre = "alejandra",
  kilometrajeDeAuto = 180000,
  viajes = [],
  condicion = tomarCualquierViaje
}

puedeTomar :: Chofer -> Viaje -> Bool
puedeTomar unChofer unViaje = (condicion unChofer) unViaje

liquidacionDe :: Chofer -> Int
liquidacionDe unChofer = sum.map costo.viajes$unChofer

realizarViaje :: Viaje -> [Chofer] -> Chofer
realizarViaje unViaje = hacerViaje unViaje .choferConMenosViaje.filter (flip puedeTomar unViaje)

choferConMenosViaje :: [Chofer] -> Chofer
choferConMenosViaje [chofer] = chofer
choferConMenosViaje (chofer1:chofer2:cola) 
  |cantidadDeViajes chofer1 < cantidadDeViajes chofer2 = choferConMenosViaje (chofer1:cola)
  |otherwise = choferConMenosViaje (chofer2:cola)

cantidadDeViajes = length.viajes

agregarViaje unaFuncion unChofer = unChofer {viajes = unaFuncion.viajes$unChofer}
hacerViaje unViaje = agregarViaje (++[unViaje])

nitoInfy :: Chofer
nitoInfy = UnChofer {
  nombre = "Nito Infy",
  kilometrajeDeAuto = 70000,
  viajes = repeat ( UnViaje (11,03,2017) lucas 50),
  condicion = tomarViajeConNombre 3
}


-- ¿Puede calcular la liquidación de Nito? Justifique.
-- No puedo calcular la liquidacion de Nito ya que tiene una lista con infinitos viaejs entonces nunca voy a poder terminar de sumar los costos del viaje
-- -¿Y saber si Nito puede tomar un viaje de Lucas de $ 500 el 2/5/2017? Justifique. 
--SI PUEDO SABERLO PORQUE NO ES necesario que la lista de viajes de nito se termine de crear para evaluar la condicion, solo necesito la condicion de nito 
--la cual me dice si puedo o no tomar el viaje , no involucra la lista de viajes

-- gongNeng :: (Ord a) => a->(a->Bool)->(b->a)-> [b]-> a
gongNeng arg1 arg2 arg3 = max arg1 . head . filter arg2 . map arg3
