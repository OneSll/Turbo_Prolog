%SHORTTRACE
CONSTANTS
accuracy = 0.001

DOMAINS
int = integer
re = real

Predicates
C_intervals(re,re,int)
f(int,re,re,re,re,re,re,re,int)
Fx(re,re,re,re,re)
Fx(re,re,re,re,re)
k_pos(re,re,re,re,re,re)
k_neg(re,re,re,re,re,re)


Clauses
C_intervals(Lb,Rb,N) :- N = (round(Rb - Lb)+1).
Fx(X,Y,A,B,C) :- Y = A*X*X+B*X+C.
f(0,_,_,_,_,_,_,_,_) :-!.
f(N,X_C,Lb,Rb,A,B,C,K,Q) :-
	A=0, B=0, C=0, write("Any X is solution!!!"),nl,!;
	A=0, B=0, not(C=0), write("No solutions!!!"),nl,!;
	(B*B-4*A*C) < 0, write("No solutions!!!"),nl,!;
	A=0, not(B=0), not(C=0), X = -C/B, X > Rb, write("No solutions!!!"),nl,!; 
	A=0, not(B=0), not(C=0), X = -C/B, X < Lb, write("No solutions!!!"),nl,!;
	A=0, not(B=0), not(C=0), X = -C/B, write("x = ", X),nl,!;
	A=0, not(B=0), C=0, X = 0, X > Rb, write("No solutions!!!"),nl,!; 
	A=0, not(B=0), C=0, X = 0, X < Lb, write("No solutions!!!"),nl,!;
	A=0, not(B=0), C=0, X = 0, write("x = ", X),nl,!; 
	Fx(X_C,Y1,A,B,C), Y1=0, write("x = ", X_C), /*write(" y = ", Y1),*/ nl,  T=X_C-1, M=N-1, f(M,T, Lb, Rb, A,B,C,K,Q),!; %работает!!!!
	T1 = X_C-1, Fx(X_C,Y1,A,B,C), Fx(T1,Y2,A,B,C), Y2*Y1 < 0, Y2 < 0, Y1 > 0, T=abs(T1-X_C), k_pos(T,T1,X_C,A,B,C);%, X_C=X_C-1, M=N-1, f(M,X_C,Lb, Rb, A,B,C,K,Q),!;
	T1 = X_C-1, Fx(X_C,Y1,A,B,C), Fx(T1,Y2,A,B,C), Y2*Y1 < 0, Y2 > 0, Y1 < 0, T=abs(T1-X_C), k_neg(T,X_C,T1,A,B,C);%, X_C=X_C-1, M=N-1, f(M,X_C,Lb,Rb, A,B,C,K,Q),!;
	
	T=X_C-1, M=N-1,P=K+1, P=Q, write("No solutions"),!;
	T=X_C-1, Fx(X_C,Y1,A,B,C), Fx(T,Y2,A,B,C), Y2*Y1 < 0, M=N-1,P=K-1, f(M,T,Lb,Rb,A,B,C,P,Q),!;
	T=X_C-1, M=N-1,P=K+1, f(M,T,Lb,Rb,A,B,C,P,Q),!.
	

k_pos(Dif, X_dvig, X_nedvig,A,B,C) :-
 
 Dif > accuracy, Fx(X_nedvig,Y1,A,B,C), Fx(X_dvig,Y2,A,B,C), T = (X_nedvig - (Y1/(Y2 - Y1))*(X_dvig-X_nedvig)), Razn = abs(abs(X_dvig)-abs(T)), Razn < accuracy, write("X = ", X_dvig), nl, k_pos(Razn,T,X_nedvig,A,B,C);
 Dif > accuracy, Fx(X_nedvig,Y1,A,B,C), Fx(X_dvig,Y2,A,B,C), T = (X_nedvig - (Y1/(Y2 - Y1))*(X_dvig-X_nedvig)), Razn = abs(abs(X_dvig)-abs(T)), k_pos(Razn,T,X_nedvig,A,B,C).


k_neg(Dif, X_dvig, X_nedvig,A,B,C) :-
 
 Dif > accuracy, Fx(X_nedvig,Y1,A,B,C), Fx(X_dvig,Y2,A,B,C), T = (X_nedvig - (Y1/(Y1 - Y2))*(X_nedvig-X_dvig)), Razn = abs(abs(X_dvig)-abs(T)), Razn < accuracy, write("X= ", X_dvig), nl, k_neg(Razn,T,X_nedvig,A,B,C);
 Dif > accuracy,Fx(X_nedvig,Y1,A,B,C), Fx(X_dvig,Y2,A,B,C), T = (X_nedvig - (Y1/(Y1 - Y2))*(X_nedvig-X_dvig)), Razn = abs(abs(X_dvig)-abs(T)), k_neg(Razn,T,X_nedvig,A,B,C).

GOAL
write("Enter a="),
readreal(A),
write("Enter b="),
readreal(B),
write("Enter c="),
readreal(C),
write("Enter left border="),
readreal(Lb),
write("Enter right border="),
readreal(Rb),
C_intervals(Lb,Rb,N),
f(N,Rb,Lb,Rb,A,B,C,0,N).
