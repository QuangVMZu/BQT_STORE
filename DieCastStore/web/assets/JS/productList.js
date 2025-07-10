const carousel = document.getElementById('carousel');
function scrollCarousel(direction) {
    const cardWidth = carousel.querySelector('.product-card').offsetWidth;
    carousel.scrollBy({left: direction * cardWidth, behavior: 'smooth'});
}

const track = document.querySelector('.banner-track');
const slides = document.querySelectorAll('.banner-slide');
const nextBtn = document.querySelector('.next-btn');
const prevBtn = document.querySelector('.prev-btn');

let currentIndex = 0;

function updateSlide() {
    const slideWidth = slides[0].clientWidth;
    track.style.transform = `translateX(-${currentIndex * slideWidth}px)`;
}

nextBtn.addEventListener('click', () => {
    if (currentIndex < slides.length - 1) {
        currentIndex++;
        updateSlide();
    }
});

prevBtn.addEventListener('click', () => {
    if (currentIndex > 0) {
        currentIndex--;
        updateSlide();
    }
});

// Swipe support (optional)
let startX = 0;
track.addEventListener('touchstart', (e) => startX = e.touches[0].clientX);
track.addEventListener('touchend', (e) => {
    const endX = e.changedTouches[0].clientX;
    if (startX - endX > 50 && currentIndex < slides.length - 1) {
        currentIndex++;
    } else if (endX - startX > 50 && currentIndex > 0) {
        currentIndex--;
    }
    updateSlide();
});

window.addEventListener('resize', updateSlide); // Responsive

