function Preloader(el) {
  this.fileList = JSON.parse(el.dataset.fileList);
}

Preloader.loadImage = function(imageSrc, callback) {
  var img;
  
  img = new Image();
  img.style.position = 'fixed';
  img.style.top = '-10000px';
  img.onload = function() {
    document.body.removeChild(img);
    callback();
  };
  
  img.src = imageSrc;
  
  document.body.appendChild(img);
};

Preloader.prototype.preload = function(complete) {
  var fileList, currentIndex;
  
  fileList = _slice(this.fileList);
  
  function loadNext() {
    var imageSrc;
    
    imageSrc = fileList.shift();
    
    if (imageSrc) Preloader.loadImage(imageSrc, loadNext);
    else complete();
  }
  
  loadNext();
};
