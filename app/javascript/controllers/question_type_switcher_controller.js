import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selector", "template", "bodyField", "answerField"]

  connect() {
    this.switchTemplate()
  }

  switchTemplate() {
    const selectedType = this.selectorTarget.value
    this.updateTemplate(selectedType)
    this.updatePlaceholders(selectedType)
  }

  updateTemplate(type) {
    const templates = {
      description: `
        <strong>📝 記述式問題のテンプレート：</strong><br>
        「〜について説明してください」<br>
        「〜の理由を述べてください」<br>
        「〜と〜の違いは何ですか？」
      `,
      multiple_choice: `
        <strong>📋 選択式問題のテンプレート：</strong><br>
        問題文<br>
        A) 選択肢1<br>
        B) 選択肢2<br>
        C) 選択肢3<br>
        D) 選択肢4
      `,
      fill_in_blank: `
        <strong>📝 穴埋め式問題のテンプレート：</strong><br>
        「〜は【　　　】である」<br>
        「〜の手順は【　　　】→【　　　】→【　　　】である」
      `
    }

    this.templateTarget.innerHTML = templates[type] || ""
  }

  updatePlaceholders(type) {
    const placeholders = {
      description: {
        body: "例：Railsのactive_recordパターンについて説明してください。",
        answer: "例：active_recordパターンとは、データベースのテーブルの1行をオブジェクトで表現し..."
      },
      multiple_choice: {
        body: "例：次のうち、Railsの命名規則として正しいのはどれ？\nA) モデル名は複数形\nB) テーブル名は単数形\nC) コントローラー名は単数形\nD) モデル名は単数形",
        answer: "例：D"
      },
      fill_in_blank: {
        body: "例：Railsでデータベースから全てのユーザーを取得するには【　　　】メソッドを使用する。",
        answer: "例：User.all"
      }
    }

    const placeholder = placeholders[type] || placeholders.description
    
    if (this.hasBodyFieldTarget) {
      this.bodyFieldTarget.placeholder = placeholder.body
    }
    if (this.hasAnswerFieldTarget) {
      this.answerFieldTarget.placeholder = placeholder.answer
    }
  }
}