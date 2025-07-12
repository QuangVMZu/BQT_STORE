function updateSelectedTotal() {
    let total = 0, selectedCount = 0;
    document.querySelectorAll('.item-checkbox:checked').forEach(checkbox => {
        const row = checkbox.closest('tr');
        const subtotal = parseFloat(row.querySelector('.subtotal').textContent.replace('$', '')) || 0;
        total += subtotal;
        selectedCount++;
    });
    document.getElementById('selectedTotal').textContent = total.toFixed(2) + ' $';
    document.getElementById('selectedCount').textContent = selectedCount;
    const checkoutBtn = document.getElementById('checkoutBtn');
    checkoutBtn.disabled = selectedCount === 0;
    checkoutBtn.classList.toggle('btn-success', selectedCount > 0);
    checkoutBtn.classList.toggle('btn-secondary', selectedCount === 0);
}

function toggleSelectAll() {
    const checked = document.getElementById('selectAll').checked;
    document.querySelectorAll('.item-checkbox').forEach(cb => cb.checked = checked);
    updateSelectedTotal();
}

function checkSelectAllStatus() {
    const all = document.querySelectorAll('.item-checkbox');
    const checked = document.querySelectorAll('.item-checkbox:checked');
    const selectAll = document.getElementById('selectAll');
    selectAll.disabled = all.length === 0;
    selectAll.checked = all.length === checked.length;
    updateSelectedTotal();
}

function checkoutSelected() {
    const selected = document.querySelectorAll('.item-checkbox:checked');
    if (selected.length === 0) {
        alert('Please select at least one product to checkout!');
        return false;
    }
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'checkout?action=showSelected';
    selected.forEach(cb => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'selectedItems';
        input.value = cb.value;
        form.appendChild(input);
    });
    document.body.appendChild(form);
    form.submit();
}

window.onload = checkSelectAllStatus;
