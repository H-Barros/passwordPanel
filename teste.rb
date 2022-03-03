require 'time'
tempo_atras  = Time.parse('2016-04-18 21:59:00')

agora = Time.parse("2016-04-19 00:00:00")


horas = (tempo_atras.hour - agora.hour).to_s
minutos = (tempo_atras.min  - agora.min).to_s
segundos = (tempo_atras.sec - agora.sec).to_s



puts *["horas: "+horas, "minutos: "+minutos, "segundos: "+segundos]