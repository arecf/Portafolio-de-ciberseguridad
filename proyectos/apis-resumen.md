Submódulo 3.1 — Introducción a JWT (JSON Web Tokens)
Introducción
JWT (JSON Web Token) es un estándar de autenticación ampliamente utilizado en APIs modernas. Permite transmitir información de forma segura entre cliente y servidor usando un formato compacto y legible.
Un JWT es un token dividido en tres partes, separadas por puntos:

HEADER.PAYLOAD.SIGNATURE
Ejemplo:

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvIjoiam9zZSIsInJvbCI6InVzZXIifQ.abc123firma
Partes:
Header: información del algoritmo de firma (ej: HS256)

Payload: datos visibles como usuario, rol, etc.

Signature: asegura que el token no fue modificado

Importante: El contenido del JWT no está cifrado, solo firmado.

Visualiza y decodifica un JWT
Puedes usar esta herramienta online:

https://jwt.io

Ejemplo visual:
HEADER: { "alg": "HS256", "typ": "JWT" } PAYLOAD: { "usuario": "ana", "rol": "admin" }
Uso típico en APIs
El JWT se envía en la cabecera de autorización:

Authorization: Bearer TOKEN
Ejemplo con curl:

curl -H "Authorization: Bearer eyJhbGciOiJI..." https://api.ejemplo.local/perfil
Submódulo 3.2 — Análisis y manipulación de JWT
Introducción
Muchos ataques en APIs modernas se deben a malas implementaciones de JWT. 


Casos comunes de debilidad en JWT
1. alg: none
Algunos servidores mal configurados permiten usar alg: none, lo que omite la verificación de firma.

Token original:

eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvIjoiam9zZSIsInJvbCI6InVzZXIifQ.ABCDEF...
Token modificado (sin firma):

eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJ1c3VhcmlvIjoiam9zZSIsInJvbCI6ImFkbWluIn0. 
2. Firma predecible (HS256 con clave débil)
Si la clave secreta usada en HS256 es débil (ej: secret, 123456), puedes firmar tu propio token falso.

Herramienta útil:

python3 -m jwt brute <token> -w rockyou.txt
3. Cambiar claims del payload
Modifica campos como:

rol

usuario

scope

exp (fecha de expiración)

Algunos servidores validan solo la firma, pero no verifican correctamente el contenido.

Submódulo 3.3 — Introducción a OAuth 2.0
Introducción
OAuth 2.0 es un protocolo de autorización que permite a las aplicaciones obtener acceso limitado a recursos protegidos sin exponer credenciales del usuario. Es ampliamente usado en APIs modernas para permitir autenticación delegada (ej: iniciar sesión con Google o GitHub).


Componentes principales de OAuth 2.0
Componente	Rol
Resource Owner	El usuario que concede acceso
Client	La app que solicita acceso
Authorization Server	Emite tokens si el usuario autoriza
Resource Server	API protegida que valida tokens
Flujo: Client Credentials
Este flujo es común en comunicación entre servidores o microservicios. No involucra interacción del usuario final.

Pasos:
El cliente envía su client_id y client_secret al Authorization Server.

Recibe un token de acceso si es válido.

Usa el token para acceder a la API.

Ejemplo con curl
Paso 1: Solicita el token
curl -X POST https://auth.ejemplo.local/token \ -d "grant_type=client_credentials" \ -d "client_id=alumno" \ -d "client_secret=clave123"
Respuesta esperada:
{ "access_token": "eyJ0eXAiOiJK...", "token_type": "Bearer", "expires_in": 3600 }
Paso 2: Usa el token en una API protegida
curl -H "Authorization: Bearer eyJ0eXAiOiJK..." https://api.ejemplo.local/perfil
Submódulo 3.4 — Ataques comunes a OAuth y malas implementaciones
Introducción
OAuth 2.0 puede ser seguro, pero una mala implementación lo convierte en una puerta abierta para atacantes. 

Vulnerabilidades comunes
1. Token Leakage (fuga de tokens)
El token se filtra en URLs, logs o referrers.

Ataque: Recolectar tokens desde historial del navegador, proxies o registros mal protegidos.

2. Redirecciones abiertas (open redirect)
El servidor permite redirigir a cualquier URL.

Ataque: Cambiar la URL final para capturar el código o token del usuario.

Ejemplo malicioso:

https://auth.ejemplo.local/auth?redirect_uri=https://evil.com
3. Reuse de authorization code
Los códigos code deben ser de un solo uso.

Ataque: Interceptar y reutilizar el código antes que el cliente legítimo.

4. Scope mal definido o no validado
Se emiten tokens con permisos demasiado amplios.

Ataque: Acceder a datos de otros usuarios o funcionalidades administrativas.

Submódulo 3.5 — Control de acceso: BOLA y BFLA
Introducción
Los errores de control de acceso son una de las vulnerabilidades más explotadas en APIs, especialmente BOLA (Broken Object Level Authorization) y BFLA (Broken Function Level Authorization).
En este submódulo aprenderás a identificar y explotar ambos tipos.

¿Qué es BOLA (Broken Object Level Authorization)?
BOLA ocurre cuando un usuario puede acceder a objetos que no le pertenecen simplemente cambiando un ID en la URL o en el cuerpo de la petición.

Ejemplo:
curl -H "Authorization: Bearer TOKEN" https://api.ejemplo.local/users/1001
Usuario autenticado como ID 1000 accede a datos del usuario 1001

El servidor no verifica si el token corresponde al dueño del recurso

¿Qué es BFLA (Broken Function Level Authorization)?
BFLA ocurre cuando un usuario accede a funcionalidades restringidas a roles superiores (ej: funciones de administrador) sin tener los permisos adecuados.

