SHORTTRACE
CONSTANTS
accuracy = 0.0001

DOMAINS 
int = integer
file = f /* f — внутреннее имя файла */
mas = real*
fl = real
PREDICATES 
createVoidMas(mas)
openFile(string,file)
readInList(mas, file, fl)
add(fl,mas,mas)
bubble(mas,mas)
permutation(mas,mas)
interpolationSearch(mas, fl, int, int,int)
length_of(mas,integer)
countMid(int, int, fl, int, int, int)
n_element(mas,int,int)
setNewLow(int, int)
setNewHig(int, int)
CLAUSES  

n_element([X|_],1,X).
n_element([_|L],N,Y):-
                N1=N-1,
                n_element(L,N1,Y).

length_of([],0).
length_of([_|T],L):- length_of(T,TailLength), L=TailLength + 1.


permutation([X,Y|T],[Y,X|T]):-
                        X>Y,!.
                              /* переставляем первые два
                                 элемента, если первый больше
                                 второго */
permutation([X|T],[X|T1]):-
                        permutation(T,T1).
                              /*переходим к перестановкам
                                в хвосте*/
bubble(L,L1):-
     permutation(L,LL), /* вызываем предикат,
                           осуществляющий перестановку */
     !,
     bubble(LL,L1). /* пытаемся еще раз отсортировать
                       полученный список */
bubble(L,L). /* если перестановок не было, значит список
                отсортирован */

add(E,[],[E]).

add(E,[H|T],[H|T1]):-add(E,T,T1).

createVoidMas([]).

openFile(Name,f):-
     existfile(Name),!, /* проверяем существование 
                        файла с именем N */
     openread(f,Name). 
	 
	 
openFile(Name,f):-
     write("File with name ",Name," not found!").
	 
countMid(LowB, HigB,K,SortedArrayLow, SortedArrayHig, Mid):- Mid = (LowB + ((K - SortedArrayLow) * (HigB - LowB)) / (SortedArrayHig - SortedArrayLow)).

setNewLow(NewL, Mid) :- NewL = Mid+1.
setNewHig(NewH, Mid) :- NewH = Mid-1.

interpolationSearch(Arr, K, LowB, HigB,B):-  B = 0, !;
 not(B=0), n_element(Arr, LowB, SortedArrayLow), K < SortedArrayLow, write("No such element in List"), interpolationSearch(Arr, K, LowB, HigB, 0);
 not(B=0),n_element(Arr, HigB, SortedArrayHig), K > SortedArrayHig, !,write("No such element in List"), interpolationSearch(Arr, K, LowB, HigB, 0);
 not(B=0),n_element(Arr, LowB, SortedArrayLow), n_element(Arr, HigB, SortedArrayHig),
 SortedArrayLow = SortedArrayHig, !, write("No such element in List"), interpolationSearch(Arr, K, LowB, HigB, 0);

n_element(Arr, LowB, SortedArrayLow), n_element(Arr, HigB, SortedArrayHig), K > SortedArrayLow, K < SortedArrayHig,
	countMid(LowB, HigB, K, SortedArrayLow, SortedArrayHig, Mid), n_element(Arr, Mid, SortedArrayMid), SortedArrayMid < K, setNewLow(NewL, Mid),
	interpolationSearch(Arr, K, NewL, HigB,1);
	
n_element(Arr, LowB, SortedArrayLow), n_element(Arr, HigB, SortedArrayHig), K > SortedArrayLow, K < SortedArrayHig,
	countMid(LowB, HigB, K, SortedArrayLow, SortedArrayHig, Mid), n_element(Arr, Mid, SortedArrayMid), SortedArrayMid > K, setNewHig(NewH, Mid),
	interpolationSearch(Arr, K, LowB, NewH,1);
	
n_element(Arr, LowB, SortedArrayLow), n_element(Arr, HigB, SortedArrayHig),countMid(LowB, HigB, K, SortedArrayLow, SortedArrayHig, Mid), write("Your element on ", Mid," Position."), interpolationSearch(Arr, K, LowB, HigB,0), !;
	

	n_element(Arr, LowB, SortedArrayLow), !, 
	(SortedArrayLow - K) < accuracy,
	write("Your element on ", LowB," Position."),
	interpolationSearch(Arr, K, LowB, HigB,0);
	
	n_element(Arr, HigB, SortedArrayHig), !,
	(SortedArrayHig - K) < accuracy,
	write("Your element on ", HigB," Position."),
	interpolationSearch(Arr, K, LowB, HigB,0).


	 
readInList(List,f, K) :- eof(f), !, nl, write("final list =", List), bubble(List, Sorted), nl,
	write("Sorted array = ", Sorted), nl, length_of(Sorted, Len), Start = 1, interpolationSearch(Sorted, K, Start, Len, 1), nl.
	 
readInList(List, f, K):-
	not(eof(f)),!,
	readreal(C),
	add(C,List,NewList),
	%write("NewList = ", NewList), nl,
	readInList(NewList,f,K).
	


GOAL /* раздел описания внутренней цели*/
write("Enter number for search:"),
readreal(C),
createVoidMas(L),
openFile("Spisoc.txt",F),
readdevice(f),
readInList(L,f,C),
closefile(f).