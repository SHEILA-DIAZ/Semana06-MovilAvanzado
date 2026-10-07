// Desarrollado por: Sheila Diaz
import UIKit

class CatalogoViewController: UIViewController {

    // Los datos fijos del caso (Regla 1)
    let productos: [Producto] = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4)
    ]

    // El carrito se crea UNA sola vez, aquí (Regla 2)
    let carrito = CarritoModel()

    @IBOutlet weak var verCarritoButton: UIButton!

    // Los 4 botones de producto apuntan a esta MISMA acción.
    // En el Inspector de Atributos, el campo "Tag" de cada botón vale 0, 1, 2 y 3.
    @IBAction func productoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "verDetalle", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            let boton = sender as! UIButton
            let destino = segue.destination as! DetalleViewController
            destino.producto = productos[boton.tag] // elige el producto según el tag
            destino.carrito = carrito               // el MISMO objeto, no una copia
        }
        // TODO B1: caso "verCarrito" -> pasa el carrito a CarritoViewController
        if segue.identifier == "verCarrito" {
            let destino = segue.destination as! CarritoViewController
            destino.carrito = carrito               // el MISMO objeto, no una copia
        }
    }

    // TODO B2: en viewWillAppear actualiza el título del botón:
    //    "Ver carrito (n)" con n = carrito.cantidadTotal()
    //    (se ejecuta cada vez que vuelves a esta pantalla, a diferencia de viewDidLoad)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verCarritoButton.setTitle("Ver carrito (\(carrito.cantidadTotal()))", for: .normal)
    }
}
