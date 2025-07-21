const track = document.querySelector('.banner-track');
let slides = document.querySelectorAll('.banner-slide');
const nextBtn = document.querySelector('.next-btn');
const slideWidth = slides[0].clientWidth;

// Clone slide đầu và gắn vào cuối (tạo ảo giác vòng lặp)
const firstClone = slides[0].cloneNode(true);
track.appendChild(firstClone);

// Cập nhật lại danh sách slide
slides = document.querySelectorAll('.banner-slide');

let currentIndex = 0;

function updateSlide(animate = true) {
    if (!animate) {
        track.style.transition = 'none';
    } else {
        track.style.transition = 'transform 0.5s ease';
    }
    track.style.transform = `translateX(-${currentIndex * slideWidth}px)`;
}

// Bắt đầu auto slide
function startAutoSlide() {
    return setInterval(() => {
        currentIndex++;
        updateSlide(true);

        // Nếu đến slide clone → sau animation → nhảy lại về slide gốc
        if (currentIndex === slides.length - 1) {
            setTimeout(() => {
                currentIndex = 0;
                updateSlide(false); // nhảy tức thời về đầu
            }, 500); // delay đúng bằng transition
        }
    }, 3000);
}

let autoSlide = startAutoSlide();

// Stop và restart khi người dùng tương tác
function resetAutoSlide() {
    clearInterval(autoSlide);
    autoSlide = startAutoSlide();
}

// Next button (vẫn giữ được hướng đúng)
nextBtn.addEventListener('click', () => {
    currentIndex++;
    updateSlide(true);
    if (currentIndex === slides.length - 1) {
        setTimeout(() => {
            currentIndex = 0;
            updateSlide(false);
        }, 500);
    }
    resetAutoSlide();
});

// Optional: Swipe điện thoại
let startX = 0;
track.addEventListener('touchstart', (e) => startX = e.touches[0].clientX);
track.addEventListener('touchend', (e) => {
    const endX = e.changedTouches[0].clientX;
    if (startX - endX > 50) {
        currentIndex++;
        updateSlide(true);
        if (currentIndex === slides.length - 1) {
            setTimeout(() => {
                currentIndex = 0;
                updateSlide(false);
            }, 500);
        }
        resetAutoSlide();
    }
});

//function scrollCarousel(direction) {
//    const carousel = document.getElementById('carousel');
//    const card = carousel.querySelector('.product-card');
//    const cardWidth = card.offsetWidth;
//    const visibleWidth = carousel.offsetWidth;
//    const scrollWidth = carousel.scrollWidth;
//    const maxScrollLeft = scrollWidth - visibleWidth;
//
//    let newScrollLeft = carousel.scrollLeft + direction * cardWidth;
//
//    // Cuộn qua trái khi đang ở đầu
//    if (newScrollLeft < 0) {
//        carousel.scrollLeft = maxScrollLeft;
//    }
//    // Cuộn qua phải khi đang ở cuối
//    else if (newScrollLeft > maxScrollLeft) {
//        carousel.scrollLeft = 0;
//    } else {
//        carousel.scrollBy({left: direction * cardWidth, behavior: 'smooth'});
//    }
//}
//
//function scrollAccessoryCarousel(direction) {
//    const carousel = document.getElementById('accessory-carousel');
//    const card = carousel.querySelector('.product-card');
//    const cardWidth = card.offsetWidth;
//    const visibleWidth = carousel.offsetWidth;
//    const scrollWidth = carousel.scrollWidth;
//    const maxScrollLeft = scrollWidth - visibleWidth;
//
//    let newScrollLeft = carousel.scrollLeft + direction * cardWidth;
//
//    if (newScrollLeft < 0) {
//        carousel.scrollLeft = maxScrollLeft;
//    } else if (newScrollLeft > maxScrollLeft) {
//        carousel.scrollLeft = 0;
//    } else {
//        carousel.scrollBy({left: direction * cardWidth, behavior: 'smooth'});
//    }
//}


function infiniteScroll(carouselId, direction) {
    const carousel = document.getElementById(carouselId);
    const cards = carousel.querySelectorAll('.product-card');
    const card = cards[0];
    const cardWidth = card.offsetWidth;

    // Nếu chưa clone thì clone phần tử đầu và cuối
    if (!carousel.dataset.cloned) {
        const first = cards[0].cloneNode(true);
        const last = cards[cards.length - 1].cloneNode(true);
        carousel.appendChild(first);
        carousel.insertBefore(last, cards[0]);
        carousel.scrollLeft += cardWidth; // Bỏ qua phần tử đầu clone
        carousel.dataset.cloned = 'true';
    }

    const maxScrollLeft = carousel.scrollWidth - carousel.clientWidth;
    let targetScroll = carousel.scrollLeft + direction * cardWidth;

    // Cuộn bình thường
    carousel.scrollTo({left: targetScroll, behavior: 'smooth'});

    // Sau khi cuộn xong, nếu vượt biên thì reset lại (không có smooth)
    setTimeout(() => {
        if (direction > 0 && targetScroll >= maxScrollLeft - cardWidth) {
            // Đang ở cuối clone, nhảy về phần tử thật đầu tiên
            carousel.scrollLeft = cardWidth;
        } else if (direction < 0 && targetScroll <= 0) {
            // Đang ở đầu clone, nhảy về phần tử thật cuối
            carousel.scrollLeft = maxScrollLeft - cardWidth * 1;
        }
    }, 300); // Delay phải đủ để cuộn mượt xong
}

// Gọi hàm đúng carousel
function scrollCarousel(direction) {
    infiniteScroll('carousel', direction);
}

function scrollAccessoryCarousel(direction) {
    infiniteScroll('accessory-carousel', direction);
}

// Khi resize: cập nhật width nếu muốn thêm responsive nâng cao
window.addEventListener('resize', () => {
    updateSlide(false);
});
