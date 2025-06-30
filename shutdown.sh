#!/bin/bash

reschedule=0

if [ -s /run/systemd/shutdown/scheduled ]; then

    while IFS="=" read -r key value; do
        declare "$key"="$value"
    done < /run/systemd/shutdown/scheduled
 
    yad --title="Desligamento Automatico" \
        --question \
        --text="Ha um desligamento agendado para as $( date -d @$(($USEC / 1000000)) )\nDeseja cancelar o desligamento?" \
        --button=Sim:0 \
        --button=Nao:1
    
    
    if [ "$?" -eq 0 ]; then
        shutdown -c
        yad --title="Desligamento Automatico" \
            --question \
            --text="Desligamento cancelado com sucesso!\nDeseja agendar um novo desligamento?" \
            --button=Sim:0 \
            --button=Nao:1 \
            --timeout=5

        reschedule=$?
    
    else
        yad --title="Desligamento Automatico" \
            --info \
            --text="Desligamento nao cancelado!" \
            --timeout=5

        reschedule=1
    fi
fi

if [ "$reschedule" -eq 0 ]; then
    hours=$( yad --title="Desligamento Automatico" \
        --scale \
        --text="Selecione quantas horas ate o desligamento:" \
        --min-value=1 \
        --max-value=24 \
        --value=2 \
        --button=OK:0 \
        --button=Cancelar:1
    )

    if [ $? -eq 0 ]; then    
        shutdown -h +$(( hours * 60 ))
        yad --title="Desligamento Automatico" \
            --info \
            --text="Desligamento agendado para daqui $hours Horas!" \
            --timeout=5
    fi
fi



