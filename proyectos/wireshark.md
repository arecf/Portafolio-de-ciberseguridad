#  Proyecto: SOC101 - Laboratorio de Seguridad y Redes

##  Objetivo
Aprender a interactuar con servicios y tráfico de red (HTTP, FTP, autenticación básica, APIs, JWT, OAuth) y analizar paquetes con Wireshark/tcpdump, resolviendo retos prácticos de pentesting y monitoreo.

##  Herramientas usadas
- Kali Linux  
- Docker + contenedores (SOC101, WebGoat, Nginx)  
- Wireshark  
- tcpdump / tshark  
- curl  
- netcat  

##  Procedimiento
**Paso 1 — Configuración del entorno**  
Levanté los laboratorios con `manage_soc101.sh` (servicios en puertos 8080, 8000, 8081). Ajusté problemas entre `docker` y `podman` y revisé el estado de los contenedores.

**Paso 2 — Análisis HTTP (GET y POST)**  
Capturé tráfico con Wireshark usando filtros:
- `http.request.method == "GET"`  
- `http.request.method == "POST"`

En las GET detecté descargas (por ejemplo `success.txt`). En las POST confirmé los datos enviados por formularios (por ejemplo: `HOLA, ESTO ES UNA PRUEBA`).

**Paso 3 — FTP inseguro**  
Me conecté a un servicio FTP expuesto en texto plano y observé cómo las credenciales y comandos viajan sin cifrar.

**Paso 4 — JWT y OAuth**  
Decodifiqué un token JWT (header, payload, firma) y pude identificar un rol oculto (`admin`) en el payload. Revisé también el flujo OAuth 2.0 (client credentials) y cómo se obtiene y usa un token de acceso.

**Paso 5 — Control de Acceso (BOLA / BFLA)**  
- **BOLA (Broken Object Level Authorization):** probé cambiar IDs en URLs (por ejemplo `/users/1000` → `/users/1001`) para comprobar si el servidor valida propiedad del recurso.  
- **BFLA (Broken Function Level Authorization):** intenté acceder a funciones administrativas con credenciales de usuario normal para verificar controles por rol.

**Paso 6 — Tráfico sospechoso y bandera secreta**  
Usé `tshark` y `tcpdump` para detectar la cabecera `X-SECRET-FLAG`. Identifiqué que la cabecera se emitía periódicamente desde los contenedores locales en tráfico HTTP y registré la evidencia.

**Paso 7 — Prueba de resistencia de autenticación (Hydra — uso en laboratorio autorizado)**  
- **Herramienta (mencionada en el laboratorio):** Hydra (uso exclusivo en el entorno del laboratorio).  
- **Objetivo:** Evaluar la resistencia de las credenciales y comprobar si existen mecanismos de protección frente a intentos repetidos (bloqueo por IP, rate-limit, etc.).  
- **Qué hice:** En el laboratorio expliqué y ejecuté pruebas controladas en un entorno autorizado, monitorizando el impacto. No publiqué ni almacené credenciales reales en el repositorio.  
- **Observación:** Documenté si el servicio activó bloqueos o devolvió códigos de error (401/429) para recomendar medidas defensivas.

## Resultados
- Capturé y analicé tráfico real HTTP/FTP.  
- Entendí cómo viajan datos sensibles (credenciales, tokens) y cómo detectarlos.  
- Identifiqué vectores comunes en APIs (BOLA, BFLA, JWT mal configurados).  
- Aprendí a usar Wireshark y tcpdump para aislar tráfico y encontrar evidencias (flags, cabeceras ocultas).  
- Resolví problemas prácticos: puertos en uso (8080/8000), contenedores reiniciando y qué interfaz usar para capturar tráfico (loopback/docker0/any).


##  Conclusión
El laboratorio fortaleció mis habilidades prácticas para análisis de tráfico y pruebas básicas de seguridad en servicios. Aprendí a diagnosticar problemas reales (interfaz incorrecta para capturas, contenedores que reinician, puertos remapeados) y a documentar evidencias de forma profesional. Estas competencias son útiles para roles de analista SOC y para pruebas autorizadas de seguridad en APIs y servicios.

---

## Evidencia



<img width="1392" height="968" alt="LAB5" src="https://github.com/user-attachments/assets/6d9d9ae1-3e3a-416f-99f8-b2b90e5b3a24" />
<img width="1230" height="613" alt="LAB6" src="https://github.com/user-attachments/assets/966e5467-234c-4b98-a50c-ee0e2806468c" />
<img width="1306" height="324" alt="LAB9" src="https://github.com/user-attachments/assets/64ec7978-7c5b-4b73-bf95-fada47344a56" />
<img width="595" height="633" alt="LAB1 1" src="https://github.com/user-attachments/assets/3c8782a6-7b98-4113-b5e6-80be6c82f2ea" />
<img width="1852" height="887" alt="LAB3 1" src="https://github.com/user-attachments/assets/242670d5-a96d-4521-842b-30827d38074b" />
<img width="1314" height="409" alt="LAB3 4" src="https://github.com/user-attachments/assets/e967345b-fca1-4071-a426-953229752d5f" />
