const plans = document.querySelector(".plans__slider");
const faqItemHead = document.querySelectorAll(".faq__item-head");

const heroMobile = document.querySelector(".hero__mobile");
const heroNav = document.querySelector(".hero__nav");
const heroClose = document.querySelector(".hero__close");
const heroNavActiveClass = "hero__nav--active";

const benefits = document.querySelector(".benefits");

if (plans) {
  new Swiper(plans, {
    slidesPerView: 1,
    spaceBetween: 10,
    loop: false,
    pagination: {
      el: ".swiper-pagination"
    }
  });
}

heroMobile.addEventListener("click", openMobileMenu);
heroClose.addEventListener("click", closeMobileMenu);

if (faqItemHead.length) {
  faqItemHead.forEach((item) => item.addEventListener("click", toggleFaq));
}

/**
 * Open active faq and close inactive faqs
 */
function toggleFaq() {
  const toggleClass = "faq__item--opened";
  faqItemHead.forEach((item) => {
    if (item !== this) {
      item.parentNode.classList.remove(toggleClass);
    }
  });
  this.parentNode.classList.toggle(toggleClass);
}

/**
 * Open hero navigation
 */
function openMobileMenu() {
  heroNav.classList.add(heroNavActiveClass);
}

/**
 * Close hero navigation
 */
function closeMobileMenu() {
  heroNav.classList.remove(heroNavActiveClass);
}
