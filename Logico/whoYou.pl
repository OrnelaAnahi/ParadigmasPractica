herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% Egon tiene una aspiradora de 200 de potencia.
% Egon y Peter tienen un trapeador, Ray y Winston no.
% Sólo Winston tiene una varita de neutrones.
% Nadie tiene una bordeadora.

tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(egon, plumero).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).


% Definir un predicado que determine si un integrante satisface la necesidad 
% de una herramienta requerida. Esto será cierto si tiene dicha herramienta,
% teniendo en cuenta que si la herramienta requerida es una aspiradora,
% el integrante debe tener una con potencia igual o superior a la requerida.
% Nota: No se pretende que sea inversible respecto a la herramienta requerida

sastifaceLaNecesidad(Integrante, aspiradora(PotenciaMinima)):-
    tiene(Integrante, aspiradora(PotenciaReal)),
    % PotenciaReal > PotenciaMinima.
    between(0, PotenciaReal, PotenciaMinima). /* PARA QUE SEA INVERSIBLE */
    

sastifaceLaNecesidad(Integrante, Herramienta):-
    tiene(Integrante, Herramienta).


% Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
% - Quien tenga una varita de neutrones puede hacer cualquier tarea, 
% independientemente de qué herramientas requiera dicha tarea.
% - Alternativamente alguien puede hacer una tarea si puede satisfacer
%  la necesidad de todas las herramientas requeridas para dicha tarea.

puedeRealizar(Integrante, Tarea):-
    tiene(Integrante, varitaDeNeutrones),
    herramientasRequeridas(Tarea, _).

% puedeRealizar(Integrante, Tarea):-
%     tiene(Integrante, _),
%     herramientasRequeridas(Tarea,_),
%     forall((herramientasRequeridas(Tarea, ListaDeTareas), member(Herramienta, ListaDeTareas)),  sastifaceLaNecesidad(Integrante, Herramienta)).

puedeRealizar(Integrante, Tarea):-
    tiene(Integrante, _),
    requiereHerramientas(Tarea,_),
    forall(requiereHerramientas(Tarea, Herramienta),  sastifaceLaNecesidad(Integrante, Herramienta)).

requiereHerramientas(Tarea, Herramienta):-
    herramientasRequeridas(Tarea, ListaDeTareas), 
    member(Herramienta, ListaDeTareas).

% Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide).
%  Para ellos disponemos de la siguiente información en la base de conocimientos:
% - tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados 
% sobre los cuales hay que realizar esa tarea.
% - precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
% Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando
%  el precio por los metros cuadrados de la tarea.

tareaPedida(juan, limpiarTecho, 10).
tareaPedida(ro, limpiarBanio, 15).
tareaPedida(diego, ordenarCuarto, 6).

precioPorTarea(limpiarTecho, 300).
precioPorTarea(limpiarBanio, 250).
precioPorTarea(ordenarCuarto, 100).

precioPorTareaPedida(Cliente, Tarea, Precio):-
    tareaPedida(Cliente, Tarea, MetrosCuadrados),
    precioPorTarea(Tarea, PrecioPorTarea),
    Precio is PrecioPorTarea * MetrosCuadrados.

precioACobrar(Cliente, PrecioTotal):-
    tareaPedida(Cliente, _, _),
    findall(PrecioPorTareasPedidas, precioPorTareaPedida(Cliente, Tarea, PrecioPorTareasPedidas), ListaDeCostoDeTareasPedidas ),
    sumlist(ListaDeCostoDeTareasPedidas, PrecioTotal).

    % Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. 
    % Un integrante acepta el pedido cuando puede realizar todas las tareas del pedido y además está dispuesto a aceptarlo.
% Winston sólo acepta pedidos que paguen más de $500,
%  Egon está dispuesto a aceptar pedidos que no tengan tareas complejas
%  y Peter está dispuesto a aceptar cualquier pedido.


esCompleja(limpiarTecho).
esCompleja(Tarea):-
    herramientasRequeridas(Tarea, ListaDeHerramientas),
    length(ListaDeHerramientas, Cantidad),
    Cantidad > 2.

puedeHacerPedido(Trabajador, Cliente):-
    tareaPedida(Cliente, _, _),
	tiene(Trabajador, _),
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizar(Trabajador, Tarea)).

estaDispuesto(ray, Cliente):-
    not(tareaPedida(Cliente, limpiarTecho, _)).

estaDispuesto(winston, Cliente):-
    precioACobrar(Cliente, Precio),
    Precio > 500.

estaDispuesto(egon, Cliente):-
    tareaPedida(Cliente, Tarea, _),
    not(esCompleja(Tarea)).

estaDispuesto(peter, _).

aceptarPedido(Trabajador, Cliente):-
    puedeHacerPedido(Trabajador, Cliente),
    estaDispuesto(Trabajador, Cliente).