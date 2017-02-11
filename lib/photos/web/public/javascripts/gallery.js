function Gallery() {
  attachEventListener('[data-gallery-advance]', 'click', function() {
    var button, currentImage, galleryImages, galleryImagesCount, currentIndex, nextImage, advancement, nextIndex;
    
    button = this;
    advancement = parseInt(this.dataset.galleryAdvance, 10);
    currentImage = button.parentNode.parentNode.parentNode;
    currentIndex = parseInt(currentImage.dataset.galleryIndex, 10);
    galleryImages = document.querySelectorAll('[data-gallery-index]');
    galleryImagesCount = galleryImages.length;
    nextIndex = currentIndex+advancement;
    
    if (nextIndex < 0) {
      nextIndex = galleryImagesCount + nextIndex
    }
    
    nextImage = document.querySelector('[data-gallery-index="'+(nextIndex % galleryImagesCount)+'"]')
    currentImage.classList.toggle('hidden', true);
    nextImage.classList.toggle('hidden', false);
  });
}
