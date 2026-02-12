

# Mini Reporte DFIR  
## Caso: Correo de “Notificación de vencimiento” con adjunto cifrado

---

# 1. Resumen Ejecutivo

Entre el 11 y 12 de febrero de 2026 se recibieron múltiples correos electrónicos con el asunto:

> “Notificación de vencimiento”

El mensaje incluía un archivo adjunto cifrado (PDF protegido con contraseña) y la contraseña era proporcionada dentro del cuerpo del correo.

Tras el análisis de los encabezados (headers), se confirmó que:

- SPF: PASS  
- DKIM: PASS  
- DMARC: PASS  

La IP de envío (23.83.210.23) pertenece a MailChannels Corporation, un servicio legítimo de relay SMTP.

Con base en la evidencia, el escenario más probable no es spoofing, sino un posible **compromiso de cuenta legítima (Account Takeover)**.

---

# 2. Información del Incidente

| Campo | Valor |
|--------|--------|
| Asunto | 7259 - Notificación de vencimiento |
| Remitente | almacen@bellaaurora.mx |
| Adjunto | PDF cifrado |
| Contraseña | Incluida en el cuerpo |
| Hora de envío | 01:01 AM |
| IP de origen | 23.83.210.23 |
| Proveedor IP | MailChannels Corporation |
| País | Canadá |

---

# 3. Análisis Técnico

## 3.1 Autenticación del correo

El análisis de encabezados arrojó:

- SPF: PASS  
- DKIM: PASS  
- DMARC: PASS  

Esto indica que:

- El correo fue enviado desde infraestructura autorizada por el dominio.
- No se trata de una suplantación simple (spoofing).
- El mensaje no fue alterado en tránsito.

---

## 3.2 Infraestructura de envío

La IP de origen corresponde a:

- Servicio legítimo de relay SMTP (MailChannels)
- Infraestructura de centro de datos
- Proveedor utilizado comúnmente por empresas de hosting

Esto refuerza la hipótesis de uso de infraestructura legítima.

---

## 3.3 Indicadores de comportamiento sospechoso

A pesar de que la autenticación fue válida, se identificaron patrones asociados a campañas maliciosas:

- Archivo adjunto cifrado (técnica de evasión de análisis automático)
- Contraseña incluida en el mismo correo
- Narrativa genérica de factura
- Ausencia de personalización
- Posible distribución masiva

El uso de archivos cifrados es una técnica común para evadir motores antivirus y filtros automáticos.

---

# 4. Hipótesis del Vector de Ataque


