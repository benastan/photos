function RemoteForm(el) {
  var remoteForm;
  remoteForm = this;
  this.el = el;
  
  this.el.addEventListener('submit', function(e) {
    e.preventDefault();
    remoteForm.submit();
  });
}

RemoteForm.dispatchEvent = function(target, eventType) {
  var event;
  
  event = new Event(eventType);
  target.dispatchEvent(event);
};

RemoteForm.prototype.submit = function() {
  var form, action, method, formData, xhr, event;
  
  form = this.el;
  action = form.action;
  method = form.method;
  formData = new FormData(form);
  
  ajaxIndicator.classList.toggle('hidden', false);
  
  xhr = new XMLHttpRequest();
  
  xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      ajaxIndicator.classList.toggle('hidden', true);

      RemoteForm.dispatchEvent('remote:complete');
      
      if (xhr.status === 200) {
        RemoteForm.dispatchEvent('remote:success');
      } else {
        RemoteForm.dispatchEvent('remote:failed');
      }
    }
  };
  
  xhr.open(method, action);
  xhr.send(formData);
};

eachMatchingSelector('[data-remote]', function(el) {
  new RemoteForm(el);
});
