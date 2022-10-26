function swipedetect(el, callback){
  var touchsurface = el,
      swipedir,
      startX,
      startY,
      distX,
      distY,
      threshold = 75, //required min distance traveled to be considered swipe
      restraint = 100000, // maximum distance allowed at the same time in perpendicular direction
      allowedTime = 300, // maximum time allowed to travel that distance
      elapsedTime,
      startTime,
      handleswipe = callback || function(swipedir){},
      touchDevice = isTouchDevice()

  function positionHandler(e) {
    swipedir = 'none'
    dist = 0
    startTime = new Date().getTime() // record time when finger first makes contact with surface
    if (touchDevice) {
      var touchobj = e.changedTouches[0]
      startX = touchobj.pageX
      startY = touchobj.pageY
    } else {
      startX = e.clientX
      startY = e.clientY
    }
    e.preventDefault()
  }

  function endHandler(e) {
    if (touchDevice) {
      var touchobj = e.changedTouches[0]
          distX = touchobj.pageX - startX // get horizontal dist traveled by finger while in contact with surface
          distY = touchobj.pageY - startY // get vertical dist traveled by finger while in contact with surface
    } else {
      distX = e.clientX - startX
      distY = e.clientY - startY
    }
    elapsedTime = new Date().getTime() - startTime // get time elapsed
    if (elapsedTime <= allowedTime){ // first condition for awipe met
      if (Math.abs(distX) >= threshold && Math.abs(distY) <= restraint){ // 2nd condition for horizontal swipe met
        swipedir = (distX < 0)? 'left' : 'right' // if dist traveled is negative, it indicates left swipe
      }
      else if (Math.abs(distY) >= threshold && Math.abs(distX) <= restraint){ // 2nd condition for vertical swipe met
        swipedir = (distY < 0)? 'up' : 'down' // if dist traveled is negative, it indicates up swipe
      }
    }
    handleswipe(swipedir)
    e.preventDefault()
  }
  touchsurface.addEventListener('touchstart', positionHandler, false )
  touchsurface.addEventListener('mousedown', positionHandler, false )

  touchsurface.addEventListener('touchmove', function(e){e.preventDefault()}, false)

  touchsurface.addEventListener('touchend', endHandler, false)
  touchsurface.addEventListener('mouseup', endHandler, false)
}

function isTouchDevice() {
  return (("ontouchstart" in window || (navigator.maxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0)))
}
export {swipedetect}
