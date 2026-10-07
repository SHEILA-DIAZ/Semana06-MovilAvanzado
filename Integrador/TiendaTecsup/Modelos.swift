// Desarrollado por: Sheila Diaz
import UIKit

class Producto {
    let nombre: String
    let precio: Double
    var stock: Int

    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int

    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }

    // Ejemplo resuelto: cada línea sabe calcular su propio subtotal
    func subtotal() -> Double {
        return producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    var items: [ItemCarrito] = []

    static let tasaIGV = 0.18

    // TODO A1: agrega respetando el stock y sin repetir líneas
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        let lineaExistente = items.first { $0.producto === producto }
        let yaEnCarrito = lineaExistente?.cantidad ?? 0

        if cantidad <= 0 || yaEnCarrito + cantidad > producto.stock {
            return false
        }

        if let linea = lineaExistente {
            linea.cantidad += cantidad
        } else {
            items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        }
        return true
    }

    // Cantidad de un producto que ya está en el carrito (para la validación de stock)
    func cantidadEnCarrito(de producto: Producto) -> Int {
        return items.first { $0.producto === producto }?.cantidad ?? 0
    }

    // TODO A2: suma de los subtotales de cada línea
    func subtotal() -> Double {
        var suma = 0.0
        for item in items {
            suma += item.subtotal()
        }
        return suma
    }

    // TODO A3: tramos de descuento sobre el subtotal (Regla 6)
    func porcentajeDescuento() -> Double {
        let sub = subtotal()
        if sub >= 5000 {
            return 0.15
        } else if sub >= 2000 {
            return 0.10
        } else if sub >= 500 {
            return 0.05
        } else {
            return 0.0
        }
    }

    // TODO A4: suma de las cantidades de todas las líneas
    func cantidadTotal() -> Int {
        var total = 0
        for item in items {
            total += item.cantidad
        }
        return total
    }

    // TODO A5: deja el carrito sin líneas
    func vaciar() {
        items.removeAll()
    }

    // Regla 9: al confirmar, el stock de cada producto baja según lo comprado
    // y el carrito se vacía
    func confirmarCompra() {
        for item in items {
            item.producto.stock -= item.cantidad
        }
        vaciar()
    }

    // Regla 5: los cálculos viven en el modelo
    func montoDescuento() -> Double {
        return subtotal() * porcentajeDescuento()
    }

    func montoConDescuento() -> Double {
        return subtotal() - montoDescuento()
    }

    // Regla 6: el IGV se calcula sobre el monto ya descontado
    func igv() -> Double {
        return montoConDescuento() * CarritoModel.tasaIGV
    }

    func total() -> Double {
        return montoConDescuento() + igv()
    }

    // Regla 7: categoría del cliente según el subtotal
    func categoriaCliente() -> String {
        switch Int(subtotal()) {
        case ..<500:
            return "Regular"
        case 500...1999:
            return "Frecuente"
        case 2000...4999:
            return "VIP"
        default:
            return "Premium"
        }
    }
}

// Reutilizado del Ejercicio 2
class ClienteModel {
    var Codigo: Int32
    var Apellido: String
    var Nombre: String
    var Dni: String

    init(pCodigo: Int32, pApellido: String, pNombre: String, pDni: String) {
        self.Codigo = pCodigo
        self.Apellido = pApellido
        self.Nombre = pNombre
        self.Dni = pDni
    }
}

// Agregado para el caso integrador (la clase del Ejercicio 2 queda igual)
extension ClienteModel {
    // Cada cliente registrado recibe un código correlativo
    static var ultimoCodigo: Int32 = 0

    static func siguienteCodigo() -> Int32 {
        ultimoCodigo += 1
        return ultimoCodigo
    }

    func nombreCompleto() -> String {
        return "\(Nombre) \(Apellido)"
    }

    // Regla 8: el DNI debe tener exactamente 8 dígitos
    static func dniEsValido(_ dni: String) -> Bool {
        return dni.count == 8 && dni.allSatisfy { $0.isASCII && $0.isNumber }
    }
}

// Formato de montos para mostrar en pantalla: "S/ 2000.00"
func soles(_ monto: Double) -> String {
    return "S/ " + String(format: "%.2f", monto)
}
