import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generateButton", "status"]

  connect() {
    console.log("Question generator controller connected")
  }

  async generateQuestion() {
    // ローディング状態を開始
    this.startLoading()

    try {
      // 学習内容を取得（post_body フィールドから）
      const learningContent = document.getElementById("post_body")?.value || ""
      
      if (!learningContent.trim()) {
        this.statusTarget.textContent = "学習内容を入力してから問題を生成してください"
        this.resetButton()
        return
      }

      const response = await fetch("/ai_generate_question", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ 
          learning_content: learningContent 
        })
      })

      if (!response.ok) throw new Error("生成失敗")

      const data = await response.json()
      
      // 問題と解答のフィールドを取得
      const bodyField = this.element.querySelector("textarea[name*='[body]']")
      const answerField = this.element.querySelector("input[name*='[question_answer]']")
      
      // nullチェックを追加
      if (bodyField) {
        bodyField.value = data.body
        // 文字数カウンターを更新
        bodyField.dispatchEvent(new Event('input'))
      } else {
        console.error("問題フィールドが見つかりません")
      }
      
      if (answerField) {
        answerField.value = data.question_answer
        // 文字数カウンターを更新
        answerField.dispatchEvent(new Event('input'))
      } else {
        console.error("解答フィールドが見つかりません")
      }
      
      // 成功状態を表示
      this.showSuccess()
    } catch (e) {
      this.showError()
      console.error(e)
    }
  }

  startLoading() {
    this.generateButtonTarget.disabled = true
    this.generateButtonTarget.innerHTML = `
      <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      生成中...
    `
    this.statusTarget.textContent = ""
  }

  showSuccess() {
    this.statusTarget.innerHTML = `
      <span class="text-green-600 flex items-center">
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
        生成完了
      </span>
    `
    this.resetButton()
    
    // 3秒後にメッセージを消す
    setTimeout(() => {
      this.statusTarget.textContent = ""
    }, 3000)
  }

  showError() {
    this.statusTarget.innerHTML = `
      <span class="text-red-600 flex items-center">
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
        生成に失敗しました
      </span>
    `
    this.resetButton()
    
    // 5秒後にメッセージを消す
    setTimeout(() => {
      this.statusTarget.textContent = ""
    }, 5000)
  }

  resetButton() {
    this.generateButtonTarget.disabled = false
    this.generateButtonTarget.innerHTML = "AIで問題を自動生成"
  }
}