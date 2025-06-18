const carousel = document.getElementById('carousel');
function scrollCarousel(direction) {
    const cardWidth = carousel.querySelector('.product-card').offsetWidth;
    carousel.scrollBy({left: direction * cardWidth, behavior: 'smooth'});
}