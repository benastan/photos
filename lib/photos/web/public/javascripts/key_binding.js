function KeyBinding(el) {
  this.el = el;
  this.setting = el.dataset.bindKey.match(KeyBinding.regExp);
  this.keyCode = this.setting[1];
  this.eventType = this.setting[2];
  KeyBinding.keyBindings.push(this);
}

KeyBinding.prototype.shouldDispatch = function() {
  return this.el.offsetParent !== null
};

KeyBinding.prototype.dispatch = function() {
  var event;
  
  if (this.eventType === 'link') {
    this.el.click();
  } else {
    event = new Event(this.eventType, { "bubbles": false, "cancelable": true });
    this.el.dispatchEvent(event);
  }
};

KeyBinding.regExp = /(\d+)\:(\w+)/;

KeyBinding.keyBindings = [];

KeyBinding.initialize = function() {
  var targets;
  
  eachMatchingSelector('[data-bind-key]', function(target) {
    new KeyBinding(target);
  });
  
  document.body.addEventListener('keydown', function(e) {
    KeyBinding.handleEvent(e);
  });
};

KeyBinding.handleEvent = function(e) {
  var keyCode, keyBindings, currentBinding, keyBindingsToDispatch;
  
  if (e.target !== document.body) return true;
  
  keyBindingsToDispatch = [];
  keyCode = e.keyCode;
  keyBindings = KeyBinding.keyBindings;
  
  for (var i = 0, ii = keyBindings.length; i < ii; i++) {
    currentBinding = keyBindings[i];
  
    if (keyCode === parseInt(currentBinding.keyCode, 10)) {
      if (currentBinding.shouldDispatch()) {
        e.preventDefault();
        e.stopPropagation();
        keyBindingsToDispatch.push(currentBinding);
      }
    }
  }

  for (i = 0, ii = keyBindingsToDispatch.length; i < ii; i++) {
    keyBindingsToDispatch[i].dispatch();
  }
};

KeyBinding.initialize();