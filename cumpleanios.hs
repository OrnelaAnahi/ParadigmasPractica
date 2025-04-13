import Text.Show.Functions

type Nombre = String
type Fecha = (Int, String)
type Lugar = String
type CantidadDeRegalos = Int


type Cumpleanio = (Nombre, Fecha, Lugar, CantidadDeRegalos)

cumpleDeGus :: Cumpleanio
cumpleDeGus = ("Gus", (8, "Marzo"), "El bolson", 314)

cumpleDeVicky :: Cumpleanio
cumpleDeVicky = ("Vicky", (13, "Abril"), "La plaza", 1000)

cumpleDeDia :: Cumpleanio
cumpleDeDia = ("Dia", (14, "Abril"), "Aula", 250)

cumpleDeRo :: Cumpleanio
cumpleDeRo = ("Ro", (14, "Abril"), "Aula", 31)

cumpleDeOrne :: Cumpleanio
cumpleDeOrne = ("Orne", (26, "Abril"), "Parque Aereo", 250)

cumpleDeLu :: Cumpleanio
cumpleDeLu = ("Lu", (2, "Septiembre"), "Casa de Lu", 150)

cumpleDeNacho :: Cumpleanio
cumpleDeNacho = ("Nacho", (28, "Septiembre"), "sala de Escape", 22)

cumpleDePetru :: Cumpleanio
cumpleDePetru = ("Petru", (28, "Mayo"), "Tecno", 24)

cumpleaniosDePdP :: [Cumpleanio]
cumpleaniosDePdP = [cumpleDeGus,cumpleDeDia,cumpleDeRo,cumpleDeOrne,cumpleDeVicky,cumpleDeLu,cumpleDeNacho,cumpleDePetru]

botinDeRegalos :: [Cumpleanio] -> CantidadDeRegalos
botinDeRegalos unosCumpleanios = (sum.map cantidadDeRegalos) unosCumpleanios

cantidadDeRegalos :: Cumpleanio -> CantidadDeRegalos
cantidadDeRegalos (_,_,_,unaCantidadDeRegalos) = unaCantidadDeRegalos

mesDeCumpleanios :: Cumpleanio -> String
mesDeCumpleanios (_,(_, unMesDeCumpleanios),_,_) = unMesDeCumpleanios

cumpleaniero :: Cumpleanio -> Nombre
cumpleaniero (unNombre,_,_,_) = unNombre

esUnCumpleaniosInolvidable :: Cumpleanio -> Bool
esUnCumpleaniosInolvidable unCumpleanio = seFestejoEn "Abril" unCumpleanio || tuvoMuchosRegalos unCumpleanio || fueDe "Gus" unCumpleanio

tuvoMuchosRegalos :: Cumpleanio -> Bool
tuvoMuchosRegalos unCumpleanio = 400 < cantidadDeRegalos unCumpleanio

seFestejoEn :: String -> Cumpleanio -> Bool
seFestejoEn unMes unCumpleanio = mesDeCumpleanios unCumpleanio == unMes

fueDe :: Nombre -> Cumpleanio -> Bool
fueDe unNombre unCumpleanio = unNombre == cumpleaniero unCumpleanio

hayCumpleaniosNavidenios :: [Cumpleanio] -> Bool
hayCumpleaniosNavidenios unosCumpleanios = any (seFestejoEn "Diciembre") unosCumpleanios

fraseSecreta :: [Cumpleanio] -> String
fraseSecreta unosCumpleanios = "La frase es " ++ (soloVocales.nombreDeTodosLosCumpleanieros) unosCumpleanios

nombreDeTodosLosCumpleanieros :: [Cumpleanio] -> String
nombreDeTodosLosCumpleanieros unosCumpleanios = (concat.map cumpleaniero) unosCumpleanios

soloVocales :: Nombre -> Nombre
soloVocales unaFrase = filter esVocal unaFrase

esVocal :: Char -> Bool
esVocal unChar = unChar == 'a' || unChar == 'e' || unChar == 'i'|| unChar == 'o'|| unChar == 'u'
