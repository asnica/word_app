import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static values = {
    create: Boolean,
    placeholder: { type: String, default: "検索..." }
  }

  connect() {
    new TomSelect(this.element, {
      plugins: ['remove_button'],
      create: this.createValue, 
      placeholder: this.placeholderValue,
      render: {
        no_results: (data, escape) => {
          return `<div class="no-results">「${escape(data.input)}」に一致する結果はありません。</div>`;
        }
      }
    })
  }
}