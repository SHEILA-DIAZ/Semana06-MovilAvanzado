# Caso Integrador — Tienda de Electrodomésticos (TiendaTecsup)

Laboratorio 06 — Navegación en UIKit · Programación en Móviles Avanzado · Tecsup

Desarrollado por: **Sheila Diaz**

Mini tienda de 5 pantallas en **UIKit + Main.storyboard**: el cliente elige productos, arma su carrito,
ingresa sus datos y recibe una boleta.

## Cómo ejecutar

1. Abrir `Integrador/TiendaTecsup.xcodeproj` en Xcode.
2. Elegir un simulador de iPhone (iOS 17 o superior) y presionar **Run**.

Bundle ID: `pe.tecsup.TiendaTecsup` · Deployment target: iOS 17.0

## Estructura

```
Integrador/
├── README.md
├── project.yml                     (configuración de XcodeGen)
├── TiendaTecsup.xcodeproj
├── Evidencias/                     (capturas de cada checkpoint)
└── TiendaTecsup/
    ├── Modelos.swift               Producto, ItemCarrito, CarritoModel, ClienteModel
    ├── CatalogoViewController.swift
    ├── DetalleViewController.swift
    ├── CarritoViewController.swift
    ├── DatosClienteViewController.swift
    ├── BoletaViewController.swift
    └── Base.lproj/Main.storyboard  las 5 pantallas, segues, IBOutlets e IBActions
```

## Flujo de pantallas y segues

```
Catálogo --Show--> Detalle
   |
   +--Show--> Carrito --Show--> Datos del cliente --Modal--> Boleta
```

| Origen → Destino | Tipo | Identifier | Datos que viajan |
|---|---|---|---|
| Catálogo → Detalle | Show | `verDetalle` | Producto elegido + CarritoModel |
| Catálogo → Carrito | Show | `verCarrito` | CarritoModel |
| Carrito → Datos del cliente | Show | `irDatosCliente` | CarritoModel |
| Datos del cliente → Boleta | Present Modally | `verBoleta` | CarritoModel + ClienteModel |

- `verDetalle` es **un solo segue**, dibujado desde el ícono amarillo del Catálogo. Los botones de producto
  (Tag 0 a 4) llaman a la misma acción `productoTapped(_:)`, que hace
  `performSegue(withIdentifier: "verDetalle", sender: sender)`. En `prepare(for:sender:)` el `tag` del botón elige el producto.
- `verBoleta` también sale del ícono amarillo. Se dispara solo cuando los datos del cliente son válidos.

## Reglas del caso: dónde se cumplen

| Regla | Implementación |
|---|---|
| 1. Datos fijos | Array `productos` en `CatalogoViewController` |
| 2. Un solo carrito | `let carrito = CarritoModel()` solo en el Catálogo; las demás pantallas lo reciben por `prepare(for:sender:)` |
| 3. Un solo segue de detalle | `verDetalle` + `tag` de cada botón |
| 4. Diseño a mano | Todas las pantallas están en `Main.storyboard` |
| 5. Cálculos en el modelo | `subtotal()`, `porcentajeDescuento()`, `montoDescuento()`, `igv()`, `total()` en `CarritoModel` |
| 6. Descuento por tramos e IGV | 5 % / 10 % / 15 % sobre el subtotal; IGV 18 % sobre el monto ya descontado |
| 7. Categoría del cliente | `categoriaCliente()` con `switch Int(subtotal())` |
| 8. Validaciones | Stock (contando lo que ya hay en el carrito), campos obligatorios, DNI de 8 dígitos y carrito vacío, cada una con `UIAlertController` |
| 9. Confirmar compra | `confirmarCompra()` baja el stock y vacía el carrito |
| 10. Prueba final | Microondas S/ 450, stock 6 (ver abajo) |

Reto opcional implementado: **Reto 1**. Al cerrar la boleta, la app vuelve directo al Catálogo con
`popToRootViewController(animated:)`.

## Escenarios de verificación

Se comprobaron en el simulador del iPhone 17 Pro.

| # | Acciones | Resultado obtenido |
|---|---|---|
| 1 | Refrigeradora x1 y Licuadora x2 → Carrito | Subtotal S/ 2500.00 · Descuento 10 % (-S/ 250.00) · IGV S/ 405.00 · Total S/ 2655.00 · VIP ✅ |
| 2 | Laptop x1 y Licuadora x1 | Subtotal S/ 3750.00 · Descuento 10 % (-S/ 375.00) · IGV S/ 607.50 · Total S/ 3982.50 · VIP ✅ |
| 3 | Laptop x4 (stock 3) | Alerta "Stock insuficiente"; el carrito no cambia ✅ |
| 4 | Licuadora x1 y, en otra visita, Licuadora x1 | Una sola línea "Licuadora x2" ✅ |
| 5 | Confirmar la compra del escenario 1 y volver al Catálogo | Stock Refrigeradora 4, Licuadora 8; carrito vacío ✅ |

Boleta obtenida en el escenario 1 (también se imprime en la consola de Xcode):

```
=========== BOLETA DE COMPRA ===========
Cliente: Ana Pérez (VIP) DNI: 12345678
----------------------------------------
Refrigeradora x1              S/ 2000.00
Licuadora x2                   S/ 500.00
----------------------------------------
Subtotal:                     S/ 2500.00
Descuento (10%):              -S/ 250.00
IGV (18%):                     S/ 405.00
TOTAL:                        S/ 2655.00
========================================
```

## Prueba final (Regla 10): Microondas S/ 450, stock 6

- **Storyboard: 1 cambio.** Se agregó un botón "Microondas - S/ 450" con Tag 4, conectado a la misma acción
  `productoTapped`. No se dibujó ningún segue nuevo.
- **Código: 1 cambio.** Se agregó una línea al array `productos`.

Detalle, Carrito, Datos del cliente y Boleta no cambiaron porque trabajan con cualquier `Producto`, y los cálculos
viven en `CarritoModel`.

## PREDICT

### PREDICT 1

> Agregas una Licuadora desde el Detalle, vuelves al Catálogo y abres otro producto. ¿El carrito es el mismo
> objeto o uno nuevo? Justifica con la Regla 2.

**Es el mismo objeto.** Según la Regla 2, el carrito se crea **una sola vez**, en el Catálogo
(`let carrito = CarritoModel()`), y se pasa a las demás pantallas por `prepare(for:sender:)`. Ninguna otra
pantalla crea un `CarritoModel`.

- `CarritoModel` es una **class**, es decir, un tipo por referencia. En `destino.carrito = carrito` no se copia el
  carrito: el Detalle recibe una referencia al mismo objeto que tiene el Catálogo.
- Al volver con *Back*, el Catálogo **no se vuelve a crear**: sigue en la pila del `UINavigationController`. Por
  eso su propiedad `carrito` es la misma de antes. El Detalle sí se destruye, pero solo guardaba una
  referencia.
- Al abrir otro producto se crea un Detalle nuevo, pero `prepare` le vuelve a pasar **la misma referencia**.

Se ve en la app: el botón muestra "Ver carrito (1)" al volver, y en el escenario 4 la segunda Licuadora se suma
a la misma línea ("Licuadora x2") en lugar de crear otra.

### PREDICT 2

> Si CarritoModel fuera struct en vez de class, ¿qué verías en el Catálogo después de agregar productos en el
> Detalle? ¿Por qué?

**El Catálogo seguiría mostrando "Ver carrito (0)", y el Carrito aparecería vacío.**

- Un `struct` es un **tipo por valor**. En `destino.carrito = carrito` se pasaría una **copia** independiente.
- `agregar(producto:cantidad:)` modificaría solo la copia del Detalle. Además, para compilar tendría que ser
  `mutating func`.
- Al volver al Catálogo se destruye el Detalle y su copia con todo lo agregado. El carrito del Catálogo nunca
  cambió, así que `cantidadTotal()` en `viewWillAppear` devuelve 0.
- Por la misma razón, la Boleta y `confirmarCompra()` trabajarían sobre copias, y el carrito del Catálogo nunca
  se vaciaría.

Para compartir un mismo carrito entre varias pantallas se necesita una referencia, por eso es `class`.

## Commits (rama `integrador`)

1. Proyecto TiendaTecsup y `Modelos.swift` (TODO A1–A5 + ClienteModel)
2. Catálogo y Detalle con un solo segue `verDetalle` (tags 0–3, TODO B1)
3. Carrito con totales del modelo y "Ver carrito (n)" en `viewWillAppear` (TODO B2)
4. Datos del cliente con validaciones y segue `irDatosCliente`
5. Boleta modal (`verBoleta`) y confirmar compra
6. Prueba final con Microondas
7. README con PREDICT 1 y PREDICT 2
