import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "icon"]

    toggle() {
        const mostrando = this.inputTarget.type === "text"

        this.inputTarget.type = mostrando ? "password" : "text"

        this.iconTarget.classList.toggle("bi-eye", mostrando)
        this.iconTarget.classList.toggle("bi-eye-slash", !mostrando)

        this.element
            .querySelector("button")
            .setAttribute(
                "aria-label",
                mostrando ? "Mostrar contraseña" : "Ocultar contraseña"
            )
    }
}