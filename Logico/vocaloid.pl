% cantante(nombre,cancion)
% cancion(nombre,cantidad)

cantante(megurineLuka, cancion(nigthFever, 4)).
cantante(megurineLuka, cancion(foreverYoung ,5)).
cantante(hatsuneMiku, cancion(tellYourWorld, 4)).
cantante(gumi, cancion(foreverYoung , 4)).
cantante(gumi, cancion(tellYourWorld , 5)).
cantante(seeU, cancion(novemberRain, 6)).
cantante(seeU,cancion(nigthFever, 5)).
% cantante(kaito).

esNovedoso(Vocaloid):-
    sabeAlMenosDosCanciones(Vocaloid),
    tiempoTotalDeCanciones(Vocaloid, DuracionTotal),
    DuracionTotal < 15.

sabeAlMenosDosCanciones(Vocaloid):-
    cantante(Vocaloid, Cancion),
    cantante(Vocaloid, OtraCancion),
    Cancion \= OtraCancion.

tiempoTotalDeCanciones(Vocaloid, DuracionTotal):-
    findall(Duracion,cantante(Vocaloid,cancion(_, Duracion)), ListaDeDuracion),
    sumlist(ListaDeDuracion, DuracionTotal).

cantidadCanciones(Vocaloid, CantidadDeCanciones):-
    findall(Duracion,cantante(Vocaloid,cancion(_, Duracion)), ListaDeDuracion),
    length(ListaDeDuracion, CantidadDeCanciones).

% esNovedoso(Vocaloid):-
    % cantante(Vocaloid, _),
    % findall(Duracion,cantante(Vocaloid,cancion(Nombre, Duracion)), ListaDeDuracion),
    % length(ListaDeDuracion, CantidadDeCanciones),
    % sumlist(ListaDeDuracion, DuracionTotal),
    % CantidadDeCanciones >= 2,
    % DuracionTotal < 15.

% esAcelerado(Vocaloid):-
%     cantante(Vocaloid, _),
%     forall(cantante(Vocaloid,cancion(_,Duracion)),Duracion =< 4).

esAcelerado(Vocaloid):-
    cantante(Vocaloid, _),
    not(noEsAcelerado(Vocaloid)).
% NO TIENE QUE TENER UNA CANCION QUE DURE MAS DE CUATRO MINUTOS
noEsAcelerado(Vocaloid):-
    cantante(Vocaloid, cancion(_, Duracion)),
    Duracion > 4.


% gigante(cantmin,durtotal)
% mediano(dirtotal)
% pequenio(cant)

concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto,_,_,_).

puedeParticipar(Cantante, Concierto):-
    cantante(Cantante, _),
    concierto(Concierto,_,_,Tipo),
    cumpleCondiciones(Cantante, Tipo).

cumpleCondiciones(Cantante, gigante(CancionesMinimas, DuracionMinima)):-
    tiempoTotalDeCanciones(Cantante, DuracionTotal),
    cantidadCanciones(Cantante, Cantidad),
    DuracionTotal > DuracionMinima, 
	Cantidad > CancionesMinimas.


cumpleCondiciones(Cantante, mediano(DuracionMaxima)):-
    tiempoTotalDeCanciones(Cantante, DuracionTotal),
    DuracionTotal < DuracionMaxima.

cumpleCondiciones(Cantante, pequenio(DuracionMinima)):-
    cantante(Cantante, cancion(_,Duracion)),
    Duracion > DuracionMinima.

masFamoso(Vocaloid):-
    cantante(Vocaloid, _),
    findall(NivelDeFama, nivelDeFama(Cantantes, NivelDeFama), NivelesDeFama),
    max_member(MaximoNivelDeFama, NivelesDeFama),
    nivelDeFama(Vocaloid, MaximoNivelDeFama).
    


nivelDeFama(Vocaloid, NivelDeFama):-
    famaTotal(Vocaloid, FamaTotal),
    cantidadCanciones(Vocaloid, Cantidad),
    NivelDeFama is FamaTotal * Cantidad.

famaTotal(Vocaloid, FamaTotal):-
    puedeParticipar(Vocaloid,_),
    findall(FamaDeConciertos,(puedeParticipar(Vocaloid, Concierto),concierto(Concierto,_,FamaDeConciertos, _)),ListaDeNivelesDeFama),
    sumlist(ListaDeNivelesDeFama, FamaTotal).