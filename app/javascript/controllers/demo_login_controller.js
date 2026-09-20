import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["email", "password"]

    completar() {
        this.emailTarget.value = "demo@bibliotecapersonal.com"
        this.passwordTarget.value = "Demo1234"

        this.emailTarget.dispatchEvent(new Event("input", { bubbles: true }))
        this.passwordTarget.dispatchEvent(new Event("input", { bubbles: true }))

        this.emailTarget.form.requestSubmit()
    }
}