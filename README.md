# Simulador OCR del DNI

Lee el **nombre**, el **apellido** y el **número de identificación** del DNI hondureño con la cámara, en automático:

1. Se acomoda el DNI dentro del recuadro.
2. La lectura empieza sola.
3. Cuando los tres datos quedan confirmados, se detiene y los guarda.

El OCR corre **en el navegador** con [Tesseract.js](https://github.com/naptha/tesseract.js). La imagen del documento y los datos no se envían a ningún servidor.

## Levantarlo

### Con Node (18 o superior)

```bash
npm install
npm start
```

Queda en `http://localhost:3000`. Para usar otro puerto, define la variable `PORT`, por ejemplo `PORT=8080 npm start`.

### Con Docker

```bash
docker build -t simulador-ocr .
docker run -d -p 8080:80 --name simulador-ocr simulador-ocr
```

Queda en `http://localhost:8080`.

### Con cualquier servidor web

Es una sola página estática: basta con servir la carpeta `public/` con nginx, Apache o IIS.

## Importante: HTTPS

El navegador **solo da acceso a la cámara en `localhost` o por HTTPS**. Si lo publicas en un servidor y lo abres por `http://ip-del-servidor`, la cámara no va a encender. Hay que ponerlo detrás de HTTPS, por ejemplo con un proxy inverso (nginx o Caddy) y un certificado.

## Requisitos del navegador

- Chrome o Edge recientes.
- Conexión a internet: Tesseract.js y el modelo de español se descargan del CDN de jsDelivr. La primera lectura tarda unos segundos más; después quedan en caché.

## Cómo funciona

- **Recuadro guía.** Solo se lee lo que está dentro del recuadro. No hay detección real de bordes (eso requeriría OpenCV): se mide el contraste de la zona para no correr el OCR sobre un cuadro vacío.
- **Limpieza de la imagen.** El recorte se pasa a blanco y negro con el método de Otsu. Así se elimina el patrón de seguridad del fondo del carnet, que el OCR confunde con texto.
- **Confirmación doble.** Cada dato se da por bueno cuando el OCR lee el mismo valor dos veces. El ruido cambia de un cuadro a otro y el dato real se repite.
- **Validación de la identidad.** El número debe tener 13 dígitos, un departamento entre 01 y 18 y un año de nacimiento posible.
- **Guardado.** Los datos quedan solo en la memoria de la pestaña y se borran al recargar. No se usa `localStorage`.
