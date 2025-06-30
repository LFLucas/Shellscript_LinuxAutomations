#!/bin/bash

preferences=$( yad --form \
	--title="Preferencias" \
	--field="Ativar Luz Noturna:CHK" \
	--field="Ativar Luz do teclado:CHK" \
	--separator="|"
)

night_light=$( echo "$preferences" | cut -d'|' -f1 )
keyboard_light=$( echo "$preferences" | cut -d'|' -f2 )

if [ "$night_light" == "TRUE" ]; then redshift -O 4000; fi
if [ "$keyboard_light" == "TRUE" ]; then xset led 3; fi
