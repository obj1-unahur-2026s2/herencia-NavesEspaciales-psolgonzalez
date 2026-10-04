class Nave {
  var velocidad = 0
  var direccion = 0
  var combustible = 0


  method acelerar(cuanto) {
    velocidad = (velocidad + cuanto).min(100000)
  }
  
  method desacelerar(cuanto) {
    velocidad = (velocidad - cuanto).max(0)
  }
  
  method irHaciaElSol() {
    direccion = 10
  }
  
  method escaparDelSol() {
    direccion = -10
  }
  
  method ponerseParaleloAlSol() {
    direccion = 0
  }
  
  method acercarseUnPocoAlSol() {
    direccion = (1 + direccion).min(10)
  }
  
  method alejarseUnPocoDelSol() {
    direccion = (direccion - 1).max(-10)
  }
  
  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)

  }
  method cargarCombustible(litros) {
    combustible = combustible + litros
  }
  method descargarCombustible(litros) {
    combustible = (combustible - litros).max(0)
  }
  method estaTranquila() = (combustible >= 4000 && velocidad <= 12000)
  
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method escapar()
  method avisar()// los pongo sin llave aca no se definen, solo los declaro
  method tienePocaActividad() 

  method estaDeRelajo() {
   return  self.estaTranquila() && self.tienePocaActividad()
  }

  
}


  class Baliza inherits Nave {

  var color
  var cambiaDeColor = false

  method cambiarColorDeBaliza(colorNuevo) {
    color = colorNuevo
    cambiaDeColor = true
  }

  override method prepararViaje() {
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }


  override method estaTranquila() {
    return super() && color != "rojo"
  }

  override method escapar() {
    self.irHaciaElSol()
  }

  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method tienePocaActividad() {
    return !cambiaDeColor
  }



}

class Pasajeros inherits Nave {
  const cantPasajeros
  var comida = 0
  var bebida = 0
  var comidaServida = 0 
  
  method cargarComida(raciones) {
    comida += raciones
  }
  
  method cargarBebida(raciones) {
    bebida += raciones
  }
  
  method descargarComida(raciones) {
    comida = (comida - raciones).max(0)

    comidaServida = comidaServida + raciones
  }
  
  method descargarBebida(raciones) {
    bebida = (bebida - raciones).max(0)
  }
  
  override method prepararViaje() { //override voy a reemplazar el comportamiento q heredé
    super() //super() = “hace lo que hacia mi padre y despues hago mis cosas”
    self.cargarBebida(6 * cantPasajeros)
    self.cargarComida(4 * cantPasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar() {
    velocidad = velocidad *2
  }
  override method avisar() {
    self.descargarBebida(cantPasajeros *2)
    self.descargarComida(cantPasajeros)
   
  }

  override method tienePocaActividad() {
    return comidaServida < 50
  }
}

class Combate inherits Nave {
  var estaInvisible = true
  var misilesDesplegados = false
  const mensajes = []
  
  method ponerseVisible() {
    estaInvisible= false
  }
  
  method ponerseInvisible() {
    estaInvisible = true
  }
  
  method estaInvisible() = estaInvisible
  
  method desplegarMisiles() {
    misilesDesplegados = true
  }
  
  method replegarMisiles() {
    misilesDesplegados = false
  }
  
  method misilesDesplegados() = misilesDesplegados
  
  method emitirMensaje(mensaje) {
    mensajes.add(mensaje)
  }
  
  method mensajesEmitidos() = mensajes
  
  method primerMensajeEmitido() = mensajes.first()
  
  method ultimoMensajeEmitido() = mensajes.last()
  
  method esEscueta() = mensajes.all({ m => m.size() <= 30 })
   //entro a mensaje cuento cada mensaje y comparo q sea menor o= a 30
  
  method emitioMensaje(mensaje) = mensajes.contains(mensaje)

  override method prepararViaje() {
    super() //   ejecuta lo de Nave
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje( "Saliendo en misión" )
  }

  override method estaTranquila() {
   return  super() &&
    !self.misilesDesplegados() &&
    !self.estaInvisible()
  }
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }

}
class Hospital inherits Pasajeros{
  var quirofanosPreparados = false

  method prepararQuirofanos() { //creo la accion para poder llamrla en amenaza
  quirofanosPreparados = true 
}

  override method estaTranquila() {
    return super() && !quirofanosPreparados
  }

override method recibirAmenaza() {
    super()
    self.prepararQuirofanos()
  }

} 
class Sigilosa inherits Combate {
  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}