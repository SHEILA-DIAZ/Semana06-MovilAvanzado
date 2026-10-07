// Desarrollado por: Sheila Diaz
import UIKit

class DatosClienteViewController: UIViewController {

    // Llega desde el Carrito en prepare(for:sender:); es el MISMO carrito
    var carrito: CarritoModel!

    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var dniTextField: UITextField!

    // Oculta el teclado al tocar fuera de los campos
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func confirmarTapped(_ sender: UIButton) {
        view.endEditing(true)
        let apellido = apellidoTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let nombre = nombreTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let dni = dniTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""

        // Regla 8: los tres campos son obligatorios
        if apellido.isEmpty || nombre.isEmpty || dni.isEmpty {
            mostrarAlerta(titulo: "Campos obligatorios",
                          mensaje: "Completa Apellidos, Nombres y DNI.")
            return
        }

        // Regla 8: el DNI debe tener exactamente 8 dígitos
        if !ClienteModel.dniEsValido(dni) {
            mostrarAlerta(titulo: "DNI inválido",
                          mensaje: "El DNI debe tener exactamente 8 dígitos.")
            return
        }

        let cliente = ClienteModel(pCodigo: ClienteModel.siguienteCodigo(),
                                   pApellido: apellido, pNombre: nombre, pDni: dni)

        // Checkpoint 5: aquí se presentará la boleta con el segue modal "verBoleta"
        mostrarAlerta(titulo: "Datos correctos",
                      mensaje: "\(cliente.nombreCompleto()) (\(carrito.categoriaCliente())) DNI: \(cliente.Dni)")
    }

    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}
