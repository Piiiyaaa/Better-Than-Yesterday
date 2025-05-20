import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generateButton", "status"]

  async generateQuestion() {
    this.statusTarget.textContent = "生成中..."
    this.generateButtonTarget.disabled = true

    try {
      const response = await fetch("/ai_generate_question", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ post_id: this.element.dataset.postId }) // 必要に応じて調整
      })

      if (!response.ok) throw new Error("生成失敗")

      const data = await response.json()
      const bodyField = this.element.querySelector("textarea[name*='[body]']")
      const answerField = this.element.querySelector("input[name*='[question_answer]']")
      bodyField.value = data.body
      answerField.value = data.question_answer
      this.statusTarget.textContent = "生成完了 ✅"
    } catch (e) {
      this.statusTarget.textContent = "生成に失敗しました"
      console.error(e)
    } finally {
      this.generateButtonTarget.disabled = false
    }
  }
}
