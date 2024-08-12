
%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tamaño, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles). 
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

% Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%jefe(jefe, subordinado)
jefe(jefeSupremo,vega).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).


ubicacionesDeBuenosAires(avellaneda).
ubicacionesDeBuenosAires(barracas).
% ubicacionesDeBuenosAires(marDelPlata).
ubicacionesDeBuenosAires(laBoca).
ubicacionesDeBuenosAires(quilmes).


% frecuenta(Agente, Ubicacion):-
%     tarea(Agente, _, _),
%     member(Ubicacion , [avellaneda, barracas, marDelPlata, laBoca]).

frecuenta(Agente, Ubicacion):-
    tarea(Agente, _, _),
    ubicacionesDeBuenosAires(Ubicacion).
    % member(Ubicacion , [avellaneda, barracas, marDelPlata, laBoca]).

frecuenta(Agente, Ubicacion):-
    tarea(Agente, _, Ubicacion).

frecuenta(vega, quilmes). %QUILMES NO EXISTE EN NUESTRA BASE DE CONOCIMIENTO DE UBICACIONES NO SE SI AGREGARLO

frecuenta(Agente, marDelPlata):-
    tarea(Agente, vigilar(ListaDeLugaresAVigilar), _),
    member(negocioDeAlfajores, ListaDeLugaresAVigilar).

ubicacionInaccesible(Ubicacion):-
    ubicacion(Ubicacion),
    not(frecuenta(_, Ubicacion)).

afincado(Agente):-
    tarea(Agente, _ , Ubicacion),
    forall(tarea(Agente,_,OtraUbicacion), not(OtraUbicacion \= Ubicacion )).


% otras opcion
% Predicado para verificar si un agente está afincado
% afincado(Agente) :-
%     % Encontrar todas las ubicaciones donde el agente realiza tareas
%     findall(Ubicacion, tarea(Agente, _, Ubicacion), Ubicaciones),
%     % Convertir la lista de ubicaciones a un conjunto para eliminar duplicados
%     list_to_set(Ubicaciones, ConjuntoUbicaciones),
%     % Verificar que el conjunto tiene solo un elemento
%     length(ConjuntoUbicaciones, 1).

cadenaDeMando([JefeDelSegundo, JefeDelTercero |Cola]):-
    jefe(JefeDelSegundo, JefeDelTercero),
    cadenaDeMando([JefeDelTercero | Cola]).
cadenaDeMando([_]).
cadenaDeMando([]).




calcularPuntos(vigilar(ListaDeNegocios), Puntos):-
    length(ListaDeNegocios, Cantidad),
    Puntos is Cantidad * 5,
%  ingerir(descripcion, tamaño, cantidad)

calcularPuntos(ingerir(_, Tamanio, Cantidad), Puntos) :-
    Puntos is Tamanio * Cantidad * (-10).

calcularPuntos(apresar(_, Recompensa), Puntos):-
    Puntos is Recompensa / 2 .

calcularPuntos(asuntosInternos(AgenteInvestigado)).

% calcularPuntos(ingerir(_, Tamanio, Cantidad), Puntos):-
%     % calcularUnidadIngerida(Tamanio, Cantidad, Unidad),
%     Puntos is Tamanio* Cantidad * (-10). 

agentePremiado(Agente):-
