use <nhf/algos/list.scad>

function firstDefined(L) = !is_undef(car(L))?car(L):firstDefined(cdr(L));
