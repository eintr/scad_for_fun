/* Basic list processing */

function head(L) = L[0];
function tail(L) = len(L)>1?[for (i=[1:len(L)-1]) L[i] ]:[];

// Lisp style
function car(L) = head(L);
function cdr(L) = tail(L);

function revert(L,result=[]) = (L==[])?result:concat(revert(cdr(L)),[car(L)]);

//echo(logo_translate([["f",10],["l",20],["f",40],["r",5],["f",33]]));

function logo_translate(l=[],path=[[0,0]],direction=0,position=[0,0]) = 
	(l==[]) ?
		(path)
		:
		((car(l)[0]=="f")?
			logo_translate(l=cdr(l),path=concat(path,[[position.x+car(l)[1]*cos(direction), position.y+car(l)[1]*sin(direction)]]),direction=direction,position=[position.x+car(l)[1]*cos(direction), position.y+car(l)[1]*sin(direction)])
			:
			((car(l)[0]=="b")?
				logo_translate(l=cdr(l),path=concat(path,[[position.x-car(l)[1]*cos(direction), position.y-car(l)[1]*sin(direction)]]),direction=direction,position=[position.x-car(l)[1]*cos(direction), position.y-car(l)[1]*sin(direction)])
				:
				((car(l)[0]=="l")?
					logo_translate(l=cdr(l),path=path,direction=direction+car(l)[1],position=position)
					:
					((car(l)[0]=="r")?
						logo_translate(l=cdr(l),path=path,direction=direction-car(l)[1],position=position)
						:
						/* Ignore unknown commands */
						logo_translate(l=cdr(l),path=path,direction=direction,position=position)
					)
				)
			)
		);
        
