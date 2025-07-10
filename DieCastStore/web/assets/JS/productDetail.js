function changeMainImage(src) {
    document.getElementById('mainImage').src = src;
}

function adjustQuantity(change) {
    const input = document.getElementById('quantityInput');
    let current = parseInt(input.value);
    let max = parseInt(input.max);
    current += change;

    if (current == 0) {
        alert("⚠️ The quantity not equal zero!");
        current = 1;
    } else {
        if (current < 1) {
            current = 1;
        } else if (current > max) {
            current = max;
            // Hiển thị cảnh báo
            alert("⚠️ The quantity exceeds the current stock!");
        }
    }
    input.value = current;
}

function setQuantity(hiddenInputId) {
    const quantity = document.getElementById('quantityInput').value;
    document.getElementById(hiddenInputId).value = quantity;
}

document.addEventListener('DOMContentLoaded', function () {
    const itemsPerPage = 4;
    const newsCards = document.querySelectorAll('.news-card');
    const pageButtons = document.querySelectorAll('.news-page-btn');

    function showPage(page) {
        newsCards.forEach((card, index) => {
            card.style.display = (index >= (page - 1) * itemsPerPage && index < page * itemsPerPage)
                    ? 'block' : 'none';
        });

        pageButtons.forEach(btn => btn.classList.remove('active'));
        const activeBtn = document.querySelector(`.news-page-btn[data-page="${page}"]`);
        if (activeBtn)
            activeBtn.classList.add('active');
    }

    pageButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const page = parseInt(btn.dataset.page);
            showPage(page);
        });
    });

    showPage(1);
});