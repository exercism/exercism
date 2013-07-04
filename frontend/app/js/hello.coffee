window.helloText = -> 'Hello, World!'

window.hello = ->
  html = JST['app/templates/hello.us'](text: helloText())
  document.body.innerHTML += html

if window.addEventListener
  window.addEventListener('DOMContentLoaded', hello, false)
else
  window.attachEvent('load', hello)