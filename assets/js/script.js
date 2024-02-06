var lastScrollTop = 0;
window.addEventListener("scroll", function() {
  var currentScroll = window.screenY || document.documentElement.scrollTop;
  var menuWrapperClasses = document.querySelector(".site-header").classList
  if (currentScroll > lastScrollTop) {
    menuWrapperClasses.add("hidden");
  } else {
    menuWrapperClasses.remove("hidden");
  }
  lastScrollTop = currentScroll;
}, false);
