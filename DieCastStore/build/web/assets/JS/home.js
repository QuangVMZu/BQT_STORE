const itemsPerPage = 8;
const newsCards = document.querySelectorAll('.news-card');
const pageButtons = document.querySelectorAll('.news-page-btn');

function showPage(page) {
    newsCards.forEach((card, index) => {
        card.style.display = (index >= (page - 1) * itemsPerPage && index < page * itemsPerPage)
                ? 'block' : 'none';
    });

    pageButtons.forEach(btn => btn.classList.remove('active'));
    document.querySelector(`.news-page-btn[data-page="${page}"]`).classList.add('active');
}

pageButtons.forEach(btn => {
    btn.addEventListener('click', () => {
        const page = parseInt(btn.dataset.page);
        showPage(page);
    });
});

// Show first page on load
showPage(1);

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