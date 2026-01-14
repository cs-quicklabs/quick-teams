import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { startDate: String }
    static targets = [
        "modalDate", "modalSession",
        "detailsTitle", "detailsDescription", "detailsDate", "detailsSession", "detailsDuration"
    ]

    showCardDetails(event) {
        event.stopPropagation()

        const jobCard = event.currentTarget
        const cardId = jobCard.dataset.cardId

        fetch(`/job_cards/${cardId}`)
            .then(response => response.json())
            .then(data => {
                this.populateDetailsModal(data)
                document.getElementById('jobCardDetailsModal').classList.remove('hidden')
            })
            .catch(error => {
                console.error('Error:', error)
                alert('Error loading card details')
            })
    }

    populateDetailsModal(cardData) {
        this.detailsTitleTarget.textContent = cardData.title
        this.detailsDescriptionTarget.textContent = cardData.description || 'No description'
        this.detailsDateTarget.textContent = new Date(cardData.date).toLocaleDateString()
        this.detailsSessionTarget.textContent = cardData.session

        const totalMinutes = cardData.slot_length * 20
        let durationText
        if (totalMinutes >= 60) {
            const hours = Math.floor(totalMinutes / 60)
            const minutes = totalMinutes % 60
            durationText = minutes > 0 ? `${hours}h ${minutes}m` : `${hours}h`
        } else {
            durationText = `${totalMinutes} min`
        }
        this.detailsDurationTarget.textContent = durationText
    }

    closeDetailsModal() {
        document.getElementById('jobCardDetailsModal').classList.add('hidden')
    }

    openModal(event) {
        // Don't allow creating cards for past dates
        const sessionSlot = event.currentTarget
        const date = sessionSlot.dataset.date
        const session = sessionSlot.dataset.session
        const today = new Date().toISOString().split('T')[0]

        if (date < today) {
            return
        }

        this.modalDateTarget.value = date
        this.modalSessionTarget.value = session

        document.getElementById('jobCardModal').classList.remove('hidden')
    }

    closeModal() {
        document.getElementById('jobCardModal').classList.add('hidden')
        this.clearModalForm()
    }

    submitForm(event) {
        event.preventDefault()

        const formData = new FormData(event.target)
        const data = Object.fromEntries(formData)

        fetch('/job_cards', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
            },
            body: JSON.stringify({ job_card: data })
        })
            .then(response => response.json())
            .then(data => {
                if (data.errors) {
                    alert('Error: ' + data.errors.join(', '))
                } else {
                    this.closeModal()
                    location.reload()
                }
            })
            .catch(error => {
                console.error('Error:', error)
                alert('An error occurred')
            })
    }

    clearModalForm() {
        const form = document.querySelector('#jobCardModal form')
        form.reset()
    }
}
