ubmodule Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"



productoXL:: String -> String
productoXL nombreDeProducto = nombreDeProducto ++ "XL"

aplicarCostoDeEnvio:: Float -> Float -> Float
aplicarCostoDeEnvio precio costoDeEnvio = precio + costoDeEnvio

aplicarDescuento:: Float -> Float -> Float
aplicarDescuento precio descuento = precio - precio*(descuento/100)


precioTotal:: Float -> Float -> Float -> Float ->  Float
precioTotal precioUnitario descuento cantidad  costoDeEnvio =  aplicarDescuento precioUnitario descuento * cantidad + costoDeEnvio

entregaSencilla :: String -> Bool
entregaSencilla diaDeEntrega = (even.length) diaDeEntrega

esProductoCodiciado :: String -> Bool
esProductoCodiciado nombreDeProducto = length nombreDeProducto > 10

esProductoDeLujo  :: String -> Bool
esProductoDeLujo nombreDeProducto = elem 'x' nombreDeProducto || elem 'z' nombreDeProducto

esProductoCorriente  :: String -> Bool
esProductoCorriente nombreDeProducto = head nombreDeProducto == 'A' || head nombreDeProducto == 'E' || head nombreDeProducto == 'I' ||
    head nombreDeProducto == 'O' || head nombreDeProducto == 'U'

esProductoDeElite  :: String -> Bool
esProductoDeElite nombreDeProducto = esProductoDeLujo nombreDeProducto && esProductoCodiciado nombreDeProducto && esProductoCorriente nombreDeProducto /= True

