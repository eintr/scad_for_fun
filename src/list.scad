/* Basic list processing */

function head(L) = L[0];
function tail(L) = len(L)>1?[for (i=[1:len(L)-1]) L[i] ]:[];

// Lisp style
function car(L) = head(L);
function cdr(L) = tail(L);
