// ===== Pagination for News Cards =====
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
showPage(1);

// ===== Banner Auto Slide =====
const bannerTrack = document.querySelector('.banner-track');
const bannerSlides = document.querySelectorAll('.banner-slide');
const nextBtn = document.querySelector('.next-btn');
const prevBtn = document.querySelector('.prev-btn');

let bannerIndex = 0;
const totalSlides = bannerSlides.length;

function updateBannerSlide() {
    bannerTrack.style.transform = `translateX(-${bannerIndex * 100}%)`;
}

nextBtn.addEventListener('click', () => {
    bannerIndex = (bannerIndex + 1) % totalSlides;
    updateBannerSlide();
});

prevBtn.addEventListener('click', () => {
    bannerIndex = (bannerIndex - 1 + totalSlides) % totalSlides;
    updateBannerSlide();
});

setInterval(() => {
    bannerIndex = (bannerIndex + 1) % totalSlides;
    updateBannerSlide();
}, 4000);

// Responsive reset
window.addEventListener('resize', updateBannerSlide);
