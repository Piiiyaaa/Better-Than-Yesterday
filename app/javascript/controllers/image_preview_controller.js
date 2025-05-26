import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "filename", "previewText"]

  connect() {
    console.log("Image preview controller connected!")
  }

  previewImage() {
    const input = this.inputTarget
    const preview = this.hasPreviewTarget ? this.previewTarget : null
    const filename = this.hasFilenameTarget ? this.filenameTarget : null
    const previewText = this.hasPreviewTextTarget ? this.previewTextTarget : null

    if (!input.files || !input.files[0]) return

    const file = input.files[0]

    // ファイル名を表示（存在する場合）
    if (filename) {
      filename.textContent = file.name
    }

    if (!file.type.startsWith('image/')) {
      if (preview) {
        preview.innerHTML = '<p class="text-red-500">有効な画像ファイルを選択してください。</p>'
      }
      return
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      if (preview) {
        if (preview.tagName.toLowerCase() === 'img') {
          // img要素の場合はsrc属性を更新
          preview.src = e.target.result
          preview.classList.remove('hidden')
        } else {
          // プロフィール画像の円形プレビュー対応
          if (preview.classList.contains('rounded-full')) {
            const img = document.createElement('img')
            img.src = e.target.result
            img.className = 'w-full h-full object-cover rounded-full'
            preview.innerHTML = ''
            preview.appendChild(img)
          } else {
            // 通常の画像プレビュー
            preview.innerHTML = `<img src="${e.target.result}" alt="Preview" class="mt-1 rounded" style="max-width: 300px; max-height: 200px;">`
          }
          preview.classList.remove('hidden')
        }
      }

      // プレビューテキストを更新（存在する場合）
      if (previewText) {
        previewText.textContent = '新しい画像（プレビュー）'
      }
    }
    reader.readAsDataURL(file)
  }
}