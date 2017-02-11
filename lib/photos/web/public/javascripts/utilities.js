function attachEventListener(selector, eventType, listener) {
  var targets;
  
  targets = document.querySelectorAll(selector);
  
  for (var i = 0, ii = targets.length; i < ii; i++) {
    targets[i].addEventListener(eventType, listener);
  }
}
function _slice(ary) {
  return Array.prototype.slice.apply(ary);
}

function eachMatchingSelector(selector, callback) {
  var targets;
  
  targets = document.querySelectorAll('[data-bind-key]');
  
  for (var i = 0, ii = targets.length; i < ii; i++) {
    callback.apply(targets[i], [targets[i], i]);
  }
}