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
let bannerSlides = document.querySelectorAll('.banner-slide');
const nextBtn = document.querySelector('.next-btn');
const prevBtn = document.querySelector('.prev-btn');

const slideWidth = bannerSlides[0].clientWidth;
let bannerIndex = 0;

// Clone slide đầu → gắn vào cuối
const firstClone = bannerSlides[0].cloneNode(true);
bannerTrack.appendChild(firstClone);

// Cập nhật lại danh sách slide
bannerSlides = document.querySelectorAll('.banner-slide');
const totalSlides = bannerSlides.length;

function updateBannerSlide(animate = true) {
    bannerTrack.style.transition = animate ? 'transform 0.5s ease' : 'none';
    bannerTrack.style.transform = `translateX(-${bannerIndex * slideWidth}px)`;
}

// Auto-slide
function startBannerAutoSlide() {
    return setInterval(() => {
        bannerIndex++;
        updateBannerSlide(true);

        // Nếu đến clone → chờ animation xong → nhảy lại đầu (mượt)
        if (bannerIndex === totalSlides - 1) {
            setTimeout(() => {
                bannerIndex = 0;
                updateBannerSlide(false);
            }, 500);
        }
    }, 4000);
}

let bannerAuto = startBannerAutoSlide();

// Điều hướng nút
nextBtn.addEventListener('click', () => {
    bannerIndex++;
    updateBannerSlide(true);
    if (bannerIndex === totalSlides - 1) {
        setTimeout(() => {
            bannerIndex = 0;
            updateBannerSlide(false);
        }, 500);
    }
    resetBannerAuto();
});

prevBtn.addEventListener('click', () => {
    // Không lùi về cuối để đảm bảo đúng hướng
    if (bannerIndex > 0) {
        bannerIndex--;
        updateBannerSlide(true);
    }
    resetBannerAuto();
});

// Reset khi người dùng nhấn
function resetBannerAuto() {
    clearInterval(bannerAuto);
    bannerAuto = startBannerAutoSlide();
}

// Resize slide
window.addEventListener('resize', () => {
    updateBannerSlide(false);
});
