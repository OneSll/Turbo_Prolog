Domains
 name, processor_name, video_card_name = string
 storage_volume, ram_volume= integer
price = real
file = datafile
arr = string*
integers = integer*
reals = real*
Database
 db_computers(name, price, processor_name, ram_volume, 
video_card_name, storage_volume )
Predicates
 repeat
 do_mbase
 menu
 process(integer)
 clear_database
 error
read_until_not_integer(integer)
read_until_not_real(real)
write_all
write_all(arr,reals,arr,integers,arr,integers, integer)
write_all_csv
write_all_csv(arr,reals,arr,integers,arr,integers)
read_rows()
front_string(string, string, string)
read_prov(integer)
find(integer)
find_name(string)
find_na(string)
Goal
 do_mbase. %запускаем 
Clauses
 repeat.
 repeat:-repeat.
 clear_database:-
 retract(db_computers(_,_,_,_,_,_)),
 fail.
 clear_database:-!.
read_prov(Vibor):- %cчитываем выбор пользователя 
readint(Vibor);
error,
Vibor = 0,
menu.
 do_mbase :-
 makewindow(1,14,112," PC DATABASE ",0,0,25,80), %главное 
меню
 menu,
 clear_database.
 menu :-
 repeat, clearwindow, %окно главного меню
 nl,
 write(" *~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~* "),nl,
 write(" | 1. Read Database from file | "),nl,
 write(" | 2. Add new PC in DB | "),nl,
 write(" | 3. Delete PC from DB | "),nl,
 write(" | 4. Edit PC in DB | "),nl,
 write(" | 5. Find PC | "),nl,
 write(" | 6. Show all data | "),nl,
 write(" | 7. Write database to file | "),nl,
 write(" | 8. Delete all DB | "),nl,
 write(" | 9. Exit | "),nl,
 write(" *~~*~~*~~*~~*~~*~~*~~*~~*~~*~~*~~* "),nl,
 write(" Choose option 1-9 : "),
 read_prov(Vibor),nl,
 process(Vibor),Vibor = 9.
process(1) :- %чтение данных с файла
makewindow(2,14,112,"Read data from file",2,20,18,40),shiftwindow(2),
write("Input File name (data.csv): "),
readln(Filename), 
existfile(Filename),
openread(datafile, Filename), 
readdevice(datafile),
read_rows(),
closefile(datafile), readdevice(keyboard),
write("DB successfully read from file."),nl,!,
write("Press space bar"), readchar(_), 
removewindow, shiftwindow(1), clearwindow, menu;
write("Error reading file!"), nl, !,
write("Press any button."),readchar(_),
removewindow, shiftwindow(1), clearwindow, menu, fail.
 process(2) :- %Добавление нового ПК
 makewindow(3,14,112,"Add data",2,20,18,58),shiftwindow(3),
 write("Please, Input PC specification:"),nl,
 write("Name: "), readln(Name),
 write("Price (RUB): "), read_until_not_real(Price),
 write("Processor name: "), readln(Processor_name),
 write("Ram volume (GB): "), 
read_until_not_integer(Ram_volume),
 write("Video card name: "), readln(Video_card_name),
 write("Storage volume (GB): "), 
read_until_not_integer(Storage_volume),
 
 
assertz(db_computers(Name,Price,Processor_name,Ram_volume,Video_card_n
ame,Storage_volume)),
 write(Name," added to DB"), nl,!,
 write("Press any button. "), readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu.
 
 process(3) :- %Удаление ПК
 makewindow(4,14,112,"Delete data",10,30,7,40),shiftwindow(4),
 write("Input PC name: "), readln(Name),
 retract(db_computers(Name,_,_,_,_,_)),
 write(Name," removed from DB "), nl, !,
 write("Press any button."), readchar(_), 
 removewindow, shiftwindow(1);
 
 write("No data."),nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1).
 
process(4) :- % Изменение ПК
makewindow(5,14,112,"Edit data",2,20,18,58),
shiftwindow(5),
 write("Input PC name: "), readln(Name1),
 retract(db_computers(Name1,_,_,_,_,_)),
write("Name: "), readln(Name),
 write("Price (RUB): "), read_until_not_real(Price),
write("Processor name: "), readln(Processor_name),
write("Ram volume (GB): "), 
read_until_not_integer(Ram_volume),
write("Video card name: "), readln(Video_card_name),
write("Storage volume (GB): "), 
read_until_not_integer(Storage_volume),
assertz(db_computers(Name,Price,Processor_name,Ram_volume,Video_c
ard_name,Storage_volume)),nl, !,
 write("Press any button."), readchar(_), 
 removewindow, shiftwindow(1);
 
 write("No data."),nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu.
 process(5) :- %Поиск ПК
 makewindow(6,14,112," Show PC ", 2,30,22,47), 
 shiftwindow(6),
 write("1. Find PC by Name "),nl,
 write(" Press space bar "),
 readchar(_),
 find(N),
 write("Press space bar"), readchar(_), 
 removewindow, shiftwindow(1), clearwindow, menu;
 
 write("Wrong input."),nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu.
 
 process(6) :- % Вывод всей БД
 makewindow(7,14,112," Show All data ", 0,0,25,80),
 shiftwindow(7),
write("Name| Price(Rub)| Processor name| Ram volume| Video card name| Storage volume"), nl,
write("-----------------------------------------------------------------------------"), nl,
write_all,
nl,!,
write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu;
 
write("No data."),nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu.
 
process(7) :- %Запись в файл
 makewindow(8,48,112," Write Database to file ", 7,30,12,47), 
 shiftwindow(8),
 write("Input file name (data.csv): "),
 readln(Filename),
 existfile(Filename), % Существует ли файл 
 openwrite(datafile, Filename), 
 writedevice(datafile), 
 write_all_csv,
 closefile(datafile), 
 writedevice(screen),
 write("DB successfully written to file."),
 nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu;
 
 write("Error writing file!"),nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu.
 
process(8) :- %Удаление всей бд
 makewindow(9,14,112," Delete All DB ",10,30,7,40), 
shiftwindow(9),
 clear_database,
 write("DB has been cleared"),
 nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu;
 
 write("Error writing file!"),nl,!,
 write("Press any button."),readchar(_),
 removewindow, shiftwindow(1), clearwindow, menu.
 
 process(9) :- clear_database, %Выход 
 write(" Goodbye! "),readchar(_),exit.
 error:-
 write("Choose number 1 to 9"), nl,
 write("(Press the spase bar to continue)"),readchar(_).
 
find(1):-clearwindow, write("Input PC name: "), readln(Name), 
find_name(Name), find_na(Name).
find(1):-write("No such PC in database!").
find(_):-write("Error ").
 
find_name(Name):- %Поиск ПК по названию
 db_computers(Name, Price, Processor_name, Ram_volume, 
Video_card_name,Storage_volume),nl,
 
write("Name: ", Name), nl,
 write("Price (RUB): ", Price), nl,
write("Processor name: ", Processor_name), nl,
write("Ram volume (GB): ", Ram_volume),nl,
write("Video card name: ", Video_card_name), nl,
write("Storage volume (GB): ", Storage_volume), nl,
nl, fail.
find_name(_).
find_na(Name):-db_computers(Name,_,_,_,_,_).
read_until_not_integer(Integer):-
 readint(Integer),
 Integer >=0, !;
 
 write("Enter integer number >=0: "),
 read_until_not_integer(Integer).
 
 
read_until_not_real(Real):-
 readreal(Real),
 Real >=0, !;
 
 write("Enter real number >=0: "),
 read_until_not_integer(Real).
write_all() :- %Вывод на экран 
findall(P1, db_computers(P1,_,_,_,_,_), P1s),
findall(P2, db_computers(_,P2,_,_,_,_), P2s),
findall(P3, db_computers(_,_,P3,_,_,_), P3s),
findall(P4, db_computers(_,_,_,P4,_,_), P4s),
findall(P5, db_computers(_,_,_,_,P5,_), P5s),
findall(P6, db_computers(_,_,_,_,_,P6), P6s),
write_all(P1s, P2s, P3s, P4s, P5s, P6s,1);
writedevice(screen).
write_all([], [], [], [], [], [],_) :- !.
write_all([P1|T1], [P2|T2], [P3|T3], [P4|T4], [P5|T5], [P6|T6],K) 
:-
 K < 6,
 NewK = K + 1,
 write(P1,", ",
 P2," (RUB), ",
 P3,", ",
 P4," (GB), ",
 P5,", ",
 P6, " (GB)"),nl,
write("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"),nl,
write_all(T1, T2, T3, T4, T5, T6, NewK).
write_all([P1|T1], [P2|T2], [P3|T3], [P4|T4], [P5|T5], [P6|T6],K) 
:-
 K = 6,
 NewK = 1,
 write(P1,", ",
 P2," (RUB), ",
 P3,", ",
 P4," (GB), ",
 P5,", ",
 P6, " (GB)"),nl,
write("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"),nl,readchar(_),
write_all(T1, T2, T3, T4, T5, T6, NewK).
write_all_csv() :- %Запись в файл
findall(P1, db_computers(P1,_,_,_,_,_), P1s),
findall(P2, db_computers(_,P2,_,_,_,_), P2s),
findall(P3, db_computers(_,_,P3,_,_,_), P3s),
findall(P4, db_computers(_,_,_,P4,_,_), P4s),
findall(P5, db_computers(_,_,_,_,P5,_), P5s),
findall(P6, db_computers(_,_,_,_,_,P6), P6s),
write_all_csv(P1s, P2s, P3s, P4s, P5s, P6s);
writedevice(screen).
write_all_csv([], [], [], [], [], []) :- !.
write_all_csv([P1|T1], [P2|T2], [P3|T3], [P4|T4], [P5|T5], 
[P6|T6]) :-
 write(P1,"; ",
 P2,"; ",
 P3,"; ",
 P4,"; ",
 P5,"; ",
 P6),nl,
write_all_csv(T1, T2, T3, T4, T5, T6).
read_rows() :-not(eof(datafile)), %Чтение 
readln(Line),
front_string(Line, F1_STR, Tail1), 
front_string(Tail1, F2_STR, Tail2), 
str_real(F2_STR, Price),
front_string(Tail2, F3_STR, Tail3), 
front_string(Tail3, F4_STR, Tail4), 
str_int(F4_STR,Ram_volume),
front_string(Tail4, F5_STR, Tail5),
front_string(Tail5, F6_STR, Tail6), 
str_int(F6_STR, Storage_volume),
assertz(db_computers(F1_STR,Price,F3_STR,Ram_volume, F5_STR, 
Storage_volume)), !, 
read_rows();
not(eof(datafile)), !,
write(" ********************************"), 
nl,
write(" * READING ERROR! * "), nl,
write(" * REMAINING DATA WAS NOT READ! * "), nl,
write(" * SOME MATERIALS ADDED! * "), nl,
write(" ******************************** "), nl; !.
front_string("", "", "") :- !.
front_string(Line, Param, Tail) :-
frontchar(Line, LineH, LineT), 
LineH = ';', !, 
Param = "", Tail = LineT;
frontchar(Line, LineH, LineT), 
LineH <> ';', !, 
front_string(LineT, T, Tail),
str_char(LineHS, LineH),
concat(LineHS, T, Param).