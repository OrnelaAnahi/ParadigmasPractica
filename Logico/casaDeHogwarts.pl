% HARRY

mago(harry, coraje).
mago(harry, amistad).
mago(harry, orgullo).
mago(harry, inteligencia).

statusDeSangre(harry, mestiza).
odiariaQuedar(harry, slytherin).

% DRACO
mago(draco, orgullo).
mago(draco, inteligencia).
statusDeSangre(draco, pura).
odiariaQuedar(draco, hufflepuff).

% HERMIONE 
mago(hermione, responsabilidad).
mago(hermione, orgullo).
mago(hermione, inteligencia).
statusDeSangre(hermione, impura).

tieneEnCuentaElSombrero(gryffindor, coraje).
tieneEnCuentaElSombrero(slytherin, orgullo).
tieneEnCuentaElSombrero(slytherin, inteligencia).
tieneEnCuentaElSombrero(ravenclaw, responsabilidad).
tieneEnCuentaElSombrero(ravenclaw, inteligencia).
tieneEnCuentaElSombrero(hufflepuff, amistad).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).


permiteEntrar(slytherin, Mago):-
    statusDeSangre(Mago, TipoDeSangre),
    TipoDeSangre \= impura.

permiteEntrar(Casa, Mago):-
    mago(Mago,_),
    Casa \= slytherin.

esApropiado(Mago,Casa):-
    casa(Casa),
    mago(Mago,_),
    forall(tieneEnCuentaElSombrero(Casa, Caracteristica), mago(Mago,Caracteristica)).
    

puedeQuedarSeleccionado(hermione, gryffindor).
puedeQuedarSeleccionado(Mago,Casa):-
    esApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odiariaQuedar(Mago, Casa)).

cadenaDeAmistades(Mago1 | Mago2 | MagosSiguientes ):-
    puedeQuedarSeleccionado(Mago1, Casa),
    puedeQuedarSeleccionado(Mago2, Casa),
    cadenaDeAmistades(Mago2 | MagosSiguientes)

cadenaDeAmistades([_]).
cadenaDeAmistades([]).

% --------------------------------------------------------------- PARTE 2 ------------------------------------------------------

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% buenaAccion(Accion, Puntos)
% irA(Lugar)

acciones(harry, fueraDeLaCama).
acciones(hermione, irA(tercerPiso)).
acciones(hermione, irA(seccionRestringidaBiblioteca)).
acciones(harry, irA(elBosque)).
acciones(harry, irA(tercerPiso)).
acciones(draco,irA(mazmorras)).
acciones(ron, buenaAccion(ganarAjedrezMagico, 50)).
acciones(hermione, buenaAccion(salvarAmigos, 50)).
acciones(harry, buenaAccion(ganarleAVoldermont, 60)).

% Lugares Prohibidos
lugarProhibido(tercerPiso, -75).
lugarProhibido(elBosque, -50).
lugarProhibido(seccionRestringidaBiblioteca, -10).

malaAccion(fueraDeLaCama, -50).
malaAccion(irA(Lugar), Puntos):-
    lugarProhibido(Lugar, Puntos).


esBuenAlumno(Mago):-
    acciones(Mago, _),
    forall(acciones(Mago, Accion), not(malaAccion(Accion, Puntaje))).

esRecurrente(Accion):-
    acciones(Mago, Accion),
    acciones(OtroMago, Accion),
    Mago \= OtroMago.


esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).


obtenerPuntos(buenaAccion(_,Puntos),Puntos).
obtenerPuntos(Accion, Puntos):-
    malaAccion(Accion, Puntos).

obtenerPuntos(_, 0).
    
puntajeTotal(Casa, Puntaje):-
    esDe(_,Casa),
    findall( Puntos, (esDe(Mago, Casa), acciones(Mago ,Accion), obtenerPuntos(Accion ,Puntos)) , ListaDePuntos),
    sumlist(ListaDePuntos, Puntaje). 

esCasaGanadora(Casa):-
    

% puntosPorMagoPorCasa(Mago ,Casa ,Accion,Puntos):-
    






    % puntosObtenidos(Mago, Puntos):-
    %     acciones(Mago,_),
    %     findall(Punto,(acciones(Mago,Accion), obtenerPuntos(Accion,Punto)), ListaDePuntos),
    %     sumlist(ListaDePuntos, Puntos).