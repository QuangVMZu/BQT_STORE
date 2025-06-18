const itemsPerPage = 4;
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