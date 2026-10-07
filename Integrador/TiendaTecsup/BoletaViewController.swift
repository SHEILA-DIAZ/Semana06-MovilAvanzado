// Desarrollado por: Sheila Diaz
import UIKit

class BoletaViewController: UIViewController {

    // Llegan desde Datos del cliente en prepare(for:sender:)
    var carrito: CarritoModel!
    var cliente: ClienteModel!

    @IBOutlet weak var clienteLabel: UILabel!
    @IBOutlet weak var detalleLabel: UILabel!

    let ancho = 40

    override func viewDidLoad() {
        super.viewDidLoad()
        // Solo se cierra con el botón "Cerrar"
        isModalInPresentation = true

        // 1) Se arma la boleta mientras el carrito todavía tiene sus líneas
        let categoria = carrito.categoriaCliente()
        let porcentaje = Int((carrito.porcentajeDescuento() * 100).rounded())
        let separador = String(repeating: "-", count: ancho)

        var lineas: [String] = []
        for item in carrito.items {
            lineas.append(fila("\(item.producto.nombre) x\(item.cantidad)", soles(item.subtotal())))
        }
        lineas.append(separador)
        lineas.append(fila("Subtotal:", soles(carrito.subtotal())))
        lineas.append(fila("Descuento (\(porcentaje)%):", "-" + soles(carrito.montoDescuento())))
        lineas.append(fila("IGV (18%):", soles(carrito.igv())))
        lineas.append(fila("TOTAL:", soles(carrito.total())))

        clienteLabel.text = "\(cliente.nombreCompleto()) (\(categoria)) · DNI \(cliente.Dni)"
        detalleLabel.text = lineas.joined(separator: "\n")

        print(" BOLETA DE COMPRA ".centrado(en: ancho, con: "="))
        print("Cliente: \(cliente.nombreCompleto()) (\(categoria)) DNI: \(cliente.Dni)")
        print(separador)
        print(lineas.joined(separator: "\n"))
        print(String(repeating: "=", count: ancho))

        // 2) Regla 9: se confirma la compra (baja el stock y se vacía el carrito)
        carrito.confirmarCompra()
    }

    // Texto a la izquierda y monto alineado a la derecha
    func fila(_ izquierda: String, _ derecha: String) -> String {
        let espacios = max(1, ancho - izquierda.count - derecha.count)
        return izquierda + String(repeating: " ", count: espacios) + derecha
    }

    // Reto 1: al cerrar la boleta se vuelve directo al Catálogo
    @IBAction func cerrarTapped(_ sender: UIButton) {
        let navegacion = (presentingViewController as? UINavigationController)
            ?? presentingViewController?.navigationController
        dismiss(animated: true) {
            navegacion?.popToRootViewController(animated: true)
        }
    }
}

extension String {
    // " BOLETA DE COMPRA " -> "=========== BOLETA DE COMPRA ==========="
    func centrado(en ancho: Int, con relleno: Character) -> String {
        let total = max(0, ancho - count)
        let izquierda = total / 2
        return String(repeating: relleno, count: izquierda) + self
            + String(repeating: relleno, count: total - izquierda)
    }
}
