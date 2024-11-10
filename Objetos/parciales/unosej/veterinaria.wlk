import primer-proyecto.animales.pepita
import animales.nano



object huellitas {
  const botiquin = ["Venda", "Venda", "Venda", "Pervinox", "Alcohol", "Gasa"]
  const property pacientes = #{nano, pepita}
  method agregarAlBotiquin(cosaAAgregar) {
    // botiquin.add(cosaAAgregar)
    self.agregarA(botiquin, cosaAAgregar)
  }
  method necesitaComprarVendas() {
    return botiquin.count({unElemento => unElemento == "Venda"}) <3
  }
  method agregarPaciente(unPaciente) {
    // paciente.add(unPaciente)
    self.agregarA(pacientes, unPaciente)
  }
  method agregarA(coleccion,unValor){
    coleccion.add(unValor)
  }
}