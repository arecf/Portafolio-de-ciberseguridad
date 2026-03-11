#  Lab 01 — Despliegue Seguro de Instancia EC2 en AWS

> **Área:** Cloud Security / AWS Fundamentals  
> **Fecha:** Marzo 2026  
> **Nivel:** Fundamentos  
> **Estado:**  Completado

---

##  Descripción del Lab

En este laboratorio práctico configuré y desplegué una instancia **EC2 en Amazon Web Services**, aplicando buenas prácticas de seguridad desde el inicio mediante la configuración de **Security Groups** con reglas de acceso controlado para los protocolos HTTP, HTTPS y SSH.

El objetivo principal fue entender cómo funciona el modelo de seguridad perimetral en la nube y cómo restringir el tráfico de red a nivel de instancia.

---

##  Objetivos de Aprendizaje

- [x] Lanzar una instancia EC2 desde la consola de AWS
- [x] Entender los tipos de instancias y sus casos de uso
- [x] Configurar Security Groups como firewall virtual
- [x] Aplicar el principio de **menor privilegio** en reglas de red
- [x] Conectarse vía SSH con autenticación por clave `.pem`
- [x] Verificar conectividad HTTP desde el navegador

---

##  Tecnologías y Servicios Usados

| Servicio/Herramienta | Uso |
|---|---|
| **AWS EC2** | Cómputo en la nube — servidor virtual |
| **Security Groups** | Firewall a nivel de instancia |
| **AWS Console** | Interfaz de gestión |
| **SSH (Git Bash)** | Acceso remoto seguro al servidor desde Windows |
| **Ubuntu 24.04 LTS** | Sistema operativo de la instancia |

---

##  Pasos del Lab — Con Evidencia

### 1. Lanzamiento de la Instancia EC2

Desde la consola de AWS, lancé una instancia con las siguientes especificaciones:

- **Nombre:** TEST SERVIDOR
- **AMI:** Ubuntu 24.04 LTS
- **Tipo:** `t3.micro`
- **Región:** us-east-1f (N. Virginia)
- **IP Pública:** 100.55.153.105
- **Estado:**  En ejecución — 3/3 comprobaciones superadas

![Instancia EC2 en ejecución](aws3.PNG)
*Panel de EC2 mostrando la instancia "TEST SERVIDOR" activa y pasando todos los health checks*

---

### 2. Detalles de la Instancia

Configuración de red asignada por AWS:

- **ID de instancia:** `i-0193637c8680aa68a`
- **IP Privada:** `172.31.66.56` (red interna VPC)
- **IP Pública:** `100.55.153.105` (acceso externo)
- **DNS Público:** `ec2-100-55-153-105.compute-1.amazonaws.com`

![Detalles de la instancia EC2](aws4.PNG)
*Resumen completo de la instancia: IPs pública/privada, DNS y estado de ejecución*

---

### 3. Conexión SSH desde Windows (Git Bash)

Me conecté de forma segura a la instancia usando el par de claves `.pem` generado durante el lanzamiento.

**Comando utilizado:**
```bash
ssh -i PARDECLAVES.pem ubuntu@ec2-100-55-153-105.compute-1.amazonaws.com
```

El servidor presentó su **fingerprint ED25519** para verificación de identidad, confirmé la autenticidad del host y establecí la conexión exitosamente.

![Conexión SSH exitosa](git2.PNG)
*Conexión SSH establecida: verificación de fingerprint ED25519 y acceso a Ubuntu 24.04 LTS en AWS*

---

### 4. Sesión Activa en el Servidor

Una vez dentro del servidor, el sistema reportó su estado en tiempo real:

| Métrica | Valor |
|---|---|
| System Load | 0.0 (sin carga) |
| Disk Usage | 25.9% de 6.71 GB |
| Memory Usage | 22% |
| Procesos activos | 110 |
| IPv4 (interfaz ens5) | 172.31.66.56 |

![Terminal SSH - Ubuntu en EC2](aws2.PNG)
*Vista desde AWS CloudShell: Ubuntu 24.04.3 LTS corriendo en la instancia EC2*

---

### 5. Verificación del Servidor Web (HTTP)

Confirmé que el servidor web es accesible públicamente a través del puerto **80 (HTTP)** desde el navegador:

![Servidor web accesible vía HTTP](aws.PNG)
*Servidor respondiendo en `http://100.55.153.105` — deploy funcional desde EC2*

> **Nota de seguridad:** El navegador muestra "No es seguro" porque se usa HTTP en lugar de HTTPS. El siguiente paso es instalar un certificado TLS/SSL (Let's Encrypt) para cifrar el tráfico por el puerto 443.

---

##  Configuración de Security Groups

Los Security Groups actúan como un **firewall stateful** que controla el tráfico entrante y saliente de la instancia.

### Reglas Inbound configuradas

| Tipo | Protocolo | Puerto | Origen | Propósito |
|---|---|---|---|---|
| SSH | TCP | 22 | Mi IP (`/32`) | Acceso administrativo restringido a mi IP |
| HTTP | TCP | 80 | 0.0.0.0/0 | Tráfico web — verificado en captura |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Tráfico web cifrado (TLS) |

### Decisiones de Seguridad Tomadas

- **SSH restringido a mi IP:** Limité el puerto 22 a mi dirección IP específica (`/32`), evitando ataques de fuerza bruta desde internet. Exponer SSH al mundo (`0.0.0.0/0`) es uno de los errores más comunes y peligrosos en instancias cloud.
- **Autenticación por clave `.pem`:** En lugar de contraseña, se usa criptografía asimétrica — significativamente más seguro.
- **HTTP como paso intermedio:** Permitido para eventual redirección a HTTPS.

---

##  Conceptos Clave Aprendidos

### ¿Qué es un Security Group?
Firewall virtual a nivel de instancia. Es **stateful**: si permites tráfico de entrada, la respuesta sale automáticamente sin regla outbound adicional. Por defecto **bloquea todo el tráfico entrante**.

### Diferencia HTTP vs HTTPS

| | HTTP (Puerto 80) | HTTPS (Puerto 443) |
|---|---|---|
| Cifrado | ❌ No |  Sí (TLS/SSL) |
| Datos en tránsito | Visibles | Cifrados |
| Evidencia en lab |  "No es seguro" | Próximo paso |

### IPs Pública vs Privada
- **IP Privada** (`172.31.x.x`): Comunicación interna dentro de la VPC
- **IP Pública** (`100.55.x.x`): Acceso desde internet — cambia al reiniciar (para IP fija → **Elastic IP**)

---

##  Reflexión de Seguridad

> El puerto **SSH (22) abierto al mundo** es uno de los vectores de ataque más explotados en instancias cloud. Los bots escanean internet constantemente buscando este puerto.
>
> En este lab apliqué dos capas de protección: restricción por IP en el Security Group + autenticación por clave criptográfica `.pem`. La práctica más avanzada sería usar **AWS Systems Manager Session Manager** para eliminar SSH expuesto completamente.

---

##  Recursos y Referencias

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Security Groups Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services)
- [Let's Encrypt — TLS gratuito](https://letsencrypt.org/)

---

##  Próximos Pasos

- [ ] Instalar certificado TLS con Let's Encrypt (HTTP → HTTPS)
- [ ] Configurar IAM Roles con principio de menor privilegio
- [ ] Implementar AWS CloudTrail para auditoría de accesos
- [ ] Practicar con VPCs, subredes públicas/privadas y NAT Gateways
- [ ] Explorar AWS GuardDuty para detección de amenazas
- [ ] **Meta:** Certificación AWS Cloud Practitioner → AWS Security Specialty

---

*Lab realizado como parte de mi proceso de aprendizaje activo en Cloud Security. *
