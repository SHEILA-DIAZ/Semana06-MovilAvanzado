// Desarrollado por: Sheila Diaz
import UIKit

class CarritoViewController: UIViewController, UITableViewDataSource {

    // Llega desde el Catálogo en prepare(for:sender:); es el MISMO carrito
    var carrito: CarritoModel!

    @IBOutlet weak var tablaItems: UITableView!
    @IBOutlet weak var vacioLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoTituloLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostrarCarrito()
    }

    // Solo muestra: todos los cálculos los hace CarritoModel (Regla 5)
    func mostrarCarrito() {
        tablaItems.reloadData()
        vacioLabel.isHidden = !carrito.items.isEmpty

        let porcentaje = Int((carrito.porcentajeDescuento() * 100).rounded())
        subtotalLabel.text = soles(carrito.subtotal())
        descuentoTituloLabel.text = "Descuento (\(porcentaje)%)"
        descuentoLabel.text = "-" + soles(carrito.montoDescuento())
        igvLabel.text = soles(carrito.igv())
        totalLabel.text = soles(carrito.total())
        categoriaLabel.text = carrito.categoriaCliente()
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carrito.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = carrito.items[indexPath.row]
        celda.textLabel?.text = "\(item.producto.nombre) x\(item.cantidad)"
        celda.detailTextLabel?.text = soles(item.subtotal())
        return celda
    }
}
