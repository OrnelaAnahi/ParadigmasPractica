module HDLGuardas
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"


data Libro = Libro{titulo::String, autor::String, cantidadDePaginas::Int} deriving (Show,Eq)
type Biblioteca = [Libro]

elVisitante :: Libro
elVisitante = Libro "El visitante" "Stephen King" 592

shingekiNoKyojinCapituloUno :: Libro
shingekiNoKyojinCapituloUno = Libro "Shingeki no Kyojin  Capitulo 1"  "Hajime Isayama" 40
shingekiNoKyojinCapituloTres :: Libro
shingekiNoKyojinCapituloTres = Libro "Shingeki no Kyojin  Capitulo 3"  "Hajime Isayama" 40
shingekiNoKyojinCapitulo127 :: Libro
shingekiNoKyojinCapitulo127 = Libro "Shingeki no Kyojin  Capitulo 127"  "Hajime Isayama" 40

fundacion :: Libro
fundacion = Libro "Fundacion" "Isaac Asimov" 230

eragon :: Libro
eragon = Libro "Eragon" "Cristopher Paolini" 544

eldest :: Libro
eldest = Libro "Eldest" "Cristopher Paolini" 700

brisignr :: Libro
brisignr = Libro "Brisignr" "Cristopher Paolini" 704

legado :: Libro
legado = Libro "Legado" "Cristopher Paolini" 811

sagaEragon :: [Libro]
sagaEragon = [eragon, eldest, brisignr, legado] 


miBiblioteca:: Biblioteca
miBiblioteca = [elVisitante, shingekiNoKyojinCapituloUno, shingekiNoKyojinCapituloTres, shingekiNoKyojinCapitulo127, fundacion, eragon, eldest, brisignr, legado]



promedioDeHojas :: Fractional a => Biblioteca -> a
promedioDeHojas biblioteca = fromIntegral (cantidadDePaginasTotal biblioteca) / fromIntegral (cantidadDeLibros biblioteca)

cantidadDePaginasTotal :: Biblioteca -> Int
cantidadDePaginasTotal biblioteca = sum $ cantidadDePaginasDeCadaLibro biblioteca

cantidadDePaginasDeCadaLibro :: Biblioteca -> [Int] 
cantidadDePaginasDeCadaLibro biblioteca = map cantidadDePaginas biblioteca

cantidadDeLibros :: Biblioteca -> Int
cantidadDeLibros biblioteca = length biblioteca

esLecturaObligatorio:: Libro -> Bool
esLecturaObligatorio libro = esDeStephenKing libro || esDeLaSagaEragon libro || esFundacion libro

esFundacion:: Libro -> Bool
esFundacion libro = libro == fundacion

esDeStephenKing:: Libro -> Bool
esDeStephenKing libro = autor libro == "Stephen King"

esDeLaSagaEragon:: Libro -> Bool
esDeLaSagaEragon libro = elem libro sagaEragon


esFantasiosa :: Biblioteca -> Bool
esFantasiosa biblioteca = tieneUnLibroDe "Cristopher Paolini" biblioteca || tieneUnLibroDe "Neil Gaiman" biblioteca

tieneUnLibroDe:: String -> Biblioteca -> Bool
tieneUnLibroDe escritor biblioteca = any (esDe escritor) biblioteca

esDe:: String -> Libro -> Bool
esDe escritor unLibro = autor unLibro == escritor

elNombreDeLaBiblioteca:: Biblioteca -> String
elNombreDeLaBiblioteca biblioteca = (sacarVocales.todosLosTitulos) biblioteca 

sacarVocales:: String -> String 
sacarVocales titulo =  filter noEsVocal titulo

noEsVocal:: Char -> Bool
noEsVocal char = char /= 'A' && char /= 'E' && char /= 'O' && char /= 'I' && char /= 'U' && char /= 'a' && char /= 'e' && char /= 'o' && char /= 'i' && char /= 'u'

todosLosTitulos:: Biblioteca -> String;
todosLosTitulos biblioteca = (concat.listaDeTitulos) biblioteca

listaDeTitulos :: Biblioteca -> [String];
listaDeTitulos biblioteca = map titulo biblioteca

esBibliotecaLigera :: Biblioteca -> Bool
esBibliotecaLigera biblioteca = (noHayLecturaMayorACuarenta.lecturasMayorACuarenta) biblioteca

noHayLecturaMayorACuarenta :: [Libro] -> Bool
noHayLecturaMayorACuarenta bibliotecaMayores = null bibliotecaMayores 

lecturasMayorACuarenta:: Biblioteca -> [Libro]
lecturasMayorACuarenta biblioteca = filter esMayorACuarenta biblioteca

esMayorACuarenta:: Libro -> Bool
esMayorACuarenta unLibro = cantidadDePaginas unLibro > 40


-- DE QUE GENERO ES UN LIBRO
-- Si tiene menos de 40 páginas, es un cómic. 💬
-- Si el autor es Stephen King, es de terror. 🤡
-- Si el autor es japonés, es un manga. 🗾
-- En cualquier otro caso, no sabemos el género. 🤷‍♀️🤷‍♂️

autoresJaponeses :: [String];
autoresJaponeses = ["Hajime Isayama"]

esUnComic:: Libro -> Bool
esUnComic unLibro = cantidadDePaginas unLibro < 40

esDeAutorJapones:: Libro -> Bool
esDeAutorJapones unLibro = elem (autor unLibro) autoresJaponeses

genero:: Libro -> String
genero unLibro
  |esDe "Stephen King" unLibro = "Terror"
  |esDeAutorJapones unLibro = "Manga"
  |esUnComic unLibro = "Comic"
  |otherwise = "Sin categoria"
