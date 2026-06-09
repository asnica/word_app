// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import Cocooned from '@notus.sh/cocooned'
document.addEventListener("turbo:load", () => {
  Cocooned.start();
});

document.addEventListener("turbo:load", function () {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
})

document.addEventListener("turbo:load", () => {
  const tagSearchInput = document.getElementById('tagDropdownSearch');

  if (tagSearchInput) {
    tagSearchInput.addEventListener('input', function () {
      const filterValue = this.value.toLowerCase();
      const tagItems = document.querySelectorAll('.tag-item');

      tagItems.forEach(item => {
        const labelText = item.textContent.toLowerCase();
        if (labelText.includes(filterValue)) {
          item.style.display = '';
        } else {
          item.style.display = 'none';
        }
      });
    });
  }
});