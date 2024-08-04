
% % atiende(persona, dia, hora de inicio, hora de fin).
% dodain atiende lunes, miércoles y viernes de 9 a 15.
atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 10, 20).

% lucas atiende los martes de 10 a 20
atiende(lucas, martes, 10, 20).

% juanC atiende los sábados y domingos de 18 a 22.
atiende(juanC, sabado, 18, 22).
atiende(juanC, domingo, 18, 22).

% juanFdS atiende los jueves de 10 a 20 y los viernes de 12 a 20.
atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

% leoC atiende los lunes y los miércoles de 14 a 18.
atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

% martu atiende los miércoles de 23 a 24.
atiende(martu, miercoles, 23, 24).

% vale atiende los mismos días y horarios que dodain y juanC.
atiende(vale, Dia, HoraInicio, HoraFin) :-
    atiende(dodain, Dia, HoraInicio, HoraFin).

atiende(vale, Dia, HoraInicio, HoraFin) :-
    atiende(juanC, Dia, HoraInicio, HoraFin).


quienAtiende(Persona, Dia, HorarioPuntual) :-
    atiende(Persona, Dia, HorarioInicio, HorarioFinal),
    between(HorarioInicio, HorarioFinal, HorarioPuntual).
    
estaForeverAlone(Persona, Dia, HorarioPuntual):-
    quienAtiende(Persona, Dia, HorarioPuntual),
    not(atiendeAlguienMas(Persona, Dia, HorarioPuntual)).

atiendeAlguienMas(Persona, Dia, HorarioPuntual):-
    quienAtiende(OtraPersona, Dia, HorarioPuntual),
    Persona \= OtraPersona.

posibilidadesDeAtencion(Dia,Personas):-
    findall(Persona,atiende(Persona,Dia,_,_), PersonasPosibles),
    combinar(PersonasPosibles,Personas).

combinar([], []).

combinar([Persona | PersonasPosibles], [Persona | Personas]) :-
    combinar(PersonasPosibles, Personas).

combinar([_ | PersonasPosibles], Personas) :-
    combinar(PersonasPosibles, Personas).

% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles


% dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, 
% cigarrillos Jockey, golosinas por $ 50
venta(dodain, fecha(10,8), [golosinas(1200), cigarrillos(jockey), golosinas(50)]).

% dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 
% 1 bebida no-alcohólica, golosinas por $ 10
venta(dodain, fecha(12,8), [bebidas(alcoholicas,8), bebidas(noAlcoholicas,1), golosinas(10)]).

% martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, 
% cigarrillos Chesterfield, Colorado y Parisiennes.
venta(martu, fecha(12,8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).

% lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
venta(lucas, fecha(11,8), [golosinas(600)])..

% lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.
venta(lucas, fecha(18,8), [bebidas(noAlcoholicas,2), cigarrillos(derby)]).

esSuertuda(Persona):-
    venta(Persona,_,[PrimerVenta|Cola]),
    esImportante(PrimerVenta).

esImportante(golosinas(Precio)):-
    Precio>100.

esImportante(cigarrillos[Lista]):-
    length(Lista, Cantidad),
    Cantidad>2.

esImportante(bebidas(alcoholicas, _)).
esImportante(bebidas(_, Cantidad)):-
    Cantidad>5.