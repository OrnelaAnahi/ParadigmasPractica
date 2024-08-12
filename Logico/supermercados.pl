%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).

%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).

% Desarrollar la lógica para agregar los siguientes descuentos
% - El arroz tiene un descuento del  $1.50. 
% - Las salchichas tienen $0,50 de descuento si no son vienisima.
% - Los lacteos tienen $2 de descuento si son leches o quesos de primera marca. (el primera marca sólo se refiere a los quesos).
% - El producto con el mayor precio unitario tiene 5% de descuento.

descuento(arroz(Marca), 1.50):-
    precioUnitario(arroz(Marca),_).

descuento(salchicas(Marca, Cantidad), 0.50):-
    precioUnitario(salchicas(Marca, Cantidad), _),
    Marca \= vienisima.

descuento(lacteo(Marca, leche), 2):-
    precioUnitario(lacteo(Marca, leche), _).

descuento(lacteo(Marca, queso), 2):-
    precioUnitario(lacteo(Marca, queso), _), 
    primeraMarca(Marca).

descuento(ProductoMayorPrecio,Descuento):-
    productoDeMayorPrecio(ProductoMayorPrecio, Precio),
    Descuento is Precio * 0.05 .

productoDeMayorPrecio(ProductoMayorPrecio, MayorPrecio):-
    findall(Precio, precioUnitario(Producto, Precio), ListaDePrecios),
    max_member(MayorPrecio, ListaDePrecios),
    precioUnitario(ProductoMayorPrecio, MayorPrecio).


    % precioUnitario(arroz(gallo),25.10).

    % 2) Saber si un cliente es comprador compulsivo, lo cual sucede si compró todos los productos de primera marca que tuvieran descuento.

compro(juan,lacteo(laSerenisima, leche)).
compro(juan,lacteo(laSerenisima, queso)).
compro(juan,lacteo(laSerenisima, crema)).
compro(juan,arroz(gallo)).

compro(lucia, lacteo(laSerenisima, leche)).
compro(ro, salchichas(vienisima,12)).

esCompradorCompulsivo(Cliente):-
    compro(Cliente,_),
    forall(descuentoDePrimeraMarca(Producto), compro(Cliente, Producto)).

esPrimeraMarcaConDescuento(Producto, Marca):-
    descuento(Producto, _), 
    primeraMarca(Marca).

%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)
descuentoDePrimeraMarca(arroz(Marca)):-
    esPrimeraMarcaConDescuento(arroz(Marca), Marca).

descuentoDePrimeraMarca(lacteo(Marca,TipoDeLacteo)):-
    esPrimeraMarcaConDescuento(lacteo(Marca,TipoDeLacteo), Marca).

descuentoDePrimeraMarca(salchicas(Marca,Cantidad)):-
    esPrimeraMarcaConDescuento(salchicas(Marca,Cantidad),Marca).

totalAPagarDeCompra(Cliente, Total):-
    compro(Cliente, _),
    findall(Precio, productoCompradoConDescuento(Cliente, Precio), PreciosConDescuentoProductos),
    sumlist(PreciosConDescuentoProductos, Total).

productoCompradoConDescuento(Cliente, Precio):-
    compro(Cliente, Producto),
    precioUnitario(Producto, Precio).
    not(descuento(Producto, _)).

productoCompradoConDescuento(Cliente, Precio):-
    compro(Cliente, Producto),
    calcularDescuento(Producto, Precio).

calcularDescuento(Producto, Precio):-
    precioUnitario(Producto, PrecioUnitario),
    descuento(Producto, Descuento),
    Precio is PrecioUnitario - Descuento.

