# specs

- Raspberry Pi
  - configuración
  - leer Arduino Serial desde Supercollider
  - lanzar audio samples en Supercollider (a partir del Arduino Serial)
  - Audio out a través de interficie externa de audio (Befaco)
- Arduino
  - leer sensores de proximidad
  - mandar serial on/off con threshold
  
  
# requerimientos
- todos los archivos de audio deben en WAV
- todos los archivos de audio deben estar equalizados, mezclados, masterizados y normalizados (en estado final en que deben ser reproducidos)
- mapa de sensores a samples (o criterio de reproducción)
- speakers autoamplificados y cables para conectarlos



# recomendaciones
- Escuchando los archivos de la carpeta "Sonidos" estos tienen diferente calidad, volumen, "fade in fade out". La recomendación -a menos que estas diferencias sea algo que se busque - es hacer un trabajo de edicion/mezcla de los archivos.
- Además hay que pensar en cómo se reproducirán los archivos. Es decir, cuáles serán los speakers/altavoces que se utilizarán para la instalación/performance y cómo estos se integrarán en las "torres". 

# dudas
- los archivos de audio se disparan en paralelo o en serie?
- como se distribuyen por los altavoces?
- se lanzan y suenan hasta el final o se lanzan y se paran al recibir un SENSOR-OFF?
