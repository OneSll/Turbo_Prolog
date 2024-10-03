%SHORTTRACE 
NOWARNINGS
DOMAINS
int = integer
file = datafile
str_list = string* % Строка из символов
str_matrix = str_list* % Матрица
int_list = integer* % Строка из символов
int_matrix = int_list* % Матрица

PREDICATES
input(int_matrix)
read_matrix_from_file(str_matrix)
string_to_int_list(string, str_list)
correct_matrix(str_matrix, int_matrix)
check_matrix(int_matrix, int_matrix, int)
check_help(int_list, int_matrix, int, int)
corrector(str_list, int_list, string)
makeNewHead(string,string)
change_neg_val_matrix(int_matrix, int_matrix)
change(int_list, int_list)
length(int_matrix, integer)
n_element(int_list,int,int)
n_element_mat(int_matrix, int,int_list)
check_city(int,int,int)
deykstra(int_matrix,int,int,int_list)
minimum(int,int,int)
find_min_g_help(int_list,int_list,int,int,int,int,int)
update_min_paths(int_list,int_list,int_list,int,int_list,int,int)
update_used(int_list,int_list,int,int)
find_path(int_matrix,int,int_list,int_list,int,int_list, int)
init_d(int, int_list,int, int)
init_used(int,int_list)
CLAUSES

input(FinMatrix) :-
	write("File name: "),
	readln(FileName), % Ввод названия файла
	existfile(FileName), % Существует ли файл
	openread(datafile, FileName), % Открытие файла для чтения
	readdevice(datafile), % Перенаправление ввода на файл
	read_matrix_from_file(Matrix),%Чтение
	%write(Matrix), nl,
	correct_matrix(Matrix, NewMatrix), %Исправляем все косяки ввода
	%write(NewMatrix),
	change_neg_val_matrix(NewMatrix, FinMatrix),
	%write(FinMatrix),

	closefile(datafile), !; % Закрытие файла

	write("Error reading file!"), nl, fail.

change_neg_val_matrix([Head|Tail], [NewHead|NewTail]) :-
	change(Head,NewHead),
	change_neg_val_matrix(Tail,NewTail).

change_neg_val_matrix([],[]).

change([Head|Tail], [NewHead|NewTail]):-
	Head < 0,
	NewHead = 30000,
	change(Tail,NewTail);

	NewHead = Head,
	change(Tail, NewTail).


change([],[]).

makeNewHead(Head,NewHead):- NewHead = Head.

	%Корректор
correct_matrix([Head|Tail],[NewHead|NewTail]) :-
	corrector(Head, NewHead, ""),
	correct_matrix(Tail, NewTail).

correct_matrix([],[]).

corrector([Head|Tail],[NewHead|NewTail], S) :-
	not(Head = "-"),
	not(S="-"),
	makeNewHead(Head,NewHead1),
	str_int(NewHead1,NewHead),
	corrector(Tail, NewTail, "");

	S = "-",
	concat(S, Head, NewHead1),
	str_int(NewHead1,NewHead),
	corrector(Tail,NewTail, "");

	corrector(Tail, [NewHead|NewTail], Head).

corrector([],[],"").

%Чтение матрицы с файла

read_matrix_from_file([Head|Tail]) :-
	readln(T), % Чтение строки
	string_to_int_list(T, Head), % Преобразование в список символов
	read_matrix_from_file(Tail).

read_matrix_from_file([]).

%Конверт строки в список символов

string_to_int_list(String, [Head|ListTail]) :-
	fronttoken(String, Head, StringTail), % Head - первый атом, StringTail - остальные
	string_to_int_list(StringTail, ListTail).

string_to_int_list("",[]).

%Длина списка

length([], 0). /* в пустом списке элементов нет */
length([_|T], L) :-
              length(T, L_T), /* L_T — количество
                                 элементов в хвосте */
              L = L_T + 1. /* L — количество элементов
                              исходного списка */ 


%Проверка корректности ввода  номеров городов
check_city(Start, Fin, Len):- Start > 0, Start < Len+1,
Fin > 0, not(Fin = Start), Fin < Len+1;

write("City input error"),
fail.

%получение N-о элемента списка
n_element([X|_],1,X).
n_element([_|L],N,Y):-
                N1=N-1,
                n_element(L,N1,Y).
				
%получение N-о элемента матрицы			
n_element_mat([X|_],1,X).
n_element_mat([_|L],N,Y):-
                N1=N-1,
                n_element_mat(L,N1,Y).
			
	
% Предикат для нахождения минимума из двух чисел
minimum(X, Y, Min) :-
    X <= Y, Min = X;
	Min = Y.


find_min_g_help(_,_,Min,NewMin,W,NewW,K):- K = 0, NewMin = Min, NewW=W,!.
	
find_min_g_help(Used,D,Min, NewMinim,W,NewW,K):-
	n_element(Used,K,T),
	T=0,
	n_element(D,K,Temp),
	Temp < Min,
	NewMin=Temp,
	S = NewMin,
	NewK = K-1,
	T3 = K,
	find_min_g_help(Used,D,NewMin, NewMinim, T3, NewW, NewK);
	
	n_element(Used,K,T),
	T=0,
	n_element(D,K,Temp),
	NewK = K-1,
	find_min_g_help(Used,D,Min, NewMinim,W, NewW, NewK);
	
	n_element(Used,K,T),
	T=1,
	NewK = K-1,
	find_min_g_help(Used,D,Min, NewMinim,W, NewW, NewK).
	

update_min_paths([],_,_,_,[],_,_):- !.	
update_min_paths([Head|Tail],Used,D,W,[H|T],Len, K):-
	n_element(Used, K,F0), %F0 = used[j]
	F0 = 0,
	n_element(D,K,F1), % F1 = d[j]
	n_element(D,W,F2), % F2 = d[w]
	Temp = F2+Head, %d[w] + m[w][j]
	minimum(F1,Temp, Min),
	H=Min,
	NewK=K+1,
	update_min_paths(Tail,Used,D,W,T,Len, NewK), !;
	
	n_element(Used, K,F0), %F0 = used[j]
	F0 = 1,
	n_element(D,K,F1), % F1 = d[j]
	H = F1,
	NewK=K+1,
	update_min_paths(Tail,Used,D,W,T,Len, NewK), !.
	

update_used([],[],_,_).
update_used([Head|Tail],[H|T],W,K) :-
	K=W,
	H=1,
	NewK= K+1,
	update_used(Tail,T,W,NewK);
	
	not(K=W),
	H=Head,
	NewK = K+1,
	update_used(Tail,T,W,NewK).

init_used(0,[]).
init_used(K,[H|T]) :-
	H=0,
	NewK=K-1,
	init_used(NewK,T).
	
init_d(L,[],_,K):- NewL = L+1, NewL=K,!.
init_d(L,[H|T],S,K) :-
	not(K=S),
	H=30000,
	NewK=K+1,
	init_d(L,T,S, NewK);
	K=S,
	H=0,
	NewK=K+1,
	init_d(L,T,S, NewK).


%Реализация алгоритма Дейкстры 

deykstra(Matrix, S, L, Paths):-
	init_used(L, Used),
	init_d(L,D,S,1),
	%write(Used), nl,
	%write(D), nl,
	find_path(Matrix,L,Used,D,30000,Paths,1);
	%write(Paths),nl;
	
	write("Something went wrong!"),
	fail.
	
find_path(_,Len,_,NewRes,_,Res,K):- NewL = Len+1, K=NewL, Res=NewRes, !.

find_path(Matrix,Len,Used,D,Min,Res,K):-

	
	find_min_g_help(Used,D,Min, NewMinim, 0,W,Len),
	NewMinim < 30000,
	%write("Minim = ",NewMinim),nl, write("W = ", W),nl,
	n_element_mat(Matrix,W,Str),
	%write("W stroka = " ,Str),nl,
	update_min_paths(Str,Used,D,W,NewRes,Len,1),
	%write("Res = ",NewRes),nl,
	update_used(Used, NewUsed,W,1),
	%write("NewUsed = ", NewUsed), nl,
	NewK = K+1,
	find_path(Matrix,Len,NewUsed,NewRes,Min,Res, NewK),!;
	
	write("No Path"),nl.
	

	
%Проверка на корректность матрицы
check_matrix([H|T], InputMatrix, NStroka):-
	check_help(H,InputMatrix,NStroka,1),
	NewNStroka = NStroka + 1,
	check_matrix(T,InputMatrix, NewNStroka);
	
	write("Incorrect matrix type, check matrix"), !,
	fail.
	
check_matrix([],_,_).
	
check_help([H|T],Ost,K, Nel):- 	%H - текущий элемента [i;j], i - номер строки, j- номер элемента,
								%K-номер текущей строки Nel - номер текущего элемента
								
								
	n_element_mat(Ost,Nel,St),		%Надо вытащить из Ost элемент [j;i] St - j-ая строка
	n_element(St,K, Prel),		%Prel - элемент [j;i]
	H = Prel,
	NewNel = Nel + 1,
	check_help(T,Ost,K, NewNel);
	
	n_element_mat(Ost,Nel,St),		%Надо вытащить из Ost элемент [j;i] St - j-ая строка
	n_element(St,Nel, Prel),		%Prel - элемент [j;i]
	not(H = Prel),
	fail.
	
check_help([],_,_,_).
	
	

	
GOAL
write("Enter number of starting city > "),
readint(Start),
write("Enter number of ending city > "),
readint(Fin),
input(InputMatrix),
check_matrix(InputMatrix, InputMatrix,1),
%write(InputMatrix), nl,
length(InputMatrix,Len),
check_city(Start, Fin, Len),
deykstra(InputMatrix, Start, Len, Paths),
n_element(Paths,Fin,R),
write("Path length is = ",R).