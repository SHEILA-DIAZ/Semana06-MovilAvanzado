// Desarrollado por: Sheila Diaz
import UIKit

class DetalleViewController: UIViewController {

    // Llegan desde el Catálogo en prepare(for:sender:)
    var producto: Producto!
    var carrito: CarritoModel!

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        nombreLabel.text = producto.nombre
        precioLabel.text = soles(producto.precio)
        stockLabel.text = "\(producto.stock)"
        cantidadStepper.value = 1
        cantidadLabel.text = "1"
    }

    @IBAction func cantidadCambio(_ sender: UIStepper) {
        cantidadLabel.text = "\(Int(sender.value))"
    }

    @IBAction func agregarTapped(_ sender: UIButton) {
        let cantidad = Int(cantidadStepper.value)

        if carrito.agregar(producto: producto, cantidad: cantidad) {
            let alerta = UIAlertController(title: "Producto agregado",
                                           message: "\(producto.nombre) x\(cantidad) se agregó al carrito.",
                                           preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            present(alerta, animated: true)
        } else {
            // Regla 8: considera lo que ya está en el carrito
            let enCarrito = carrito.cantidadEnCarrito(de: producto)
            let disponible = producto.stock - enCarrito
            let alerta = UIAlertController(title: "Stock insuficiente",
                                           message: "Stock de \(producto.nombre): \(producto.stock). Ya tienes \(enCarrito) en el carrito; solo puedes agregar \(disponible) más.",
                                           preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default))
            present(alerta, animated: true)
        }
    }
}
