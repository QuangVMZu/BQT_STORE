function toggleShippingForm() {
    const form = document.getElementById("shippingForm");
    const isChecked = document.getElementById("toggleShippingInfo").checked;

    // Hiển thị hoặc ẩn form
    form.style.display = isChecked ? "block" : "none";

    // Bật/tắt required tùy theo checkbox
    document.getElementById("customerName").required = isChecked;
    document.getElementById("phone").required = isChecked;
    document.getElementById("address").required = isChecked;
}

function validateForm() {
    const isChecked = document.getElementById("toggleShippingInfo").checked;

    if (isChecked) {
        const name = document.getElementById("customerName").value.trim();
        const phone = document.getElementById("phone").value.trim();
        const address = document.getElementById("address").value.trim();
        const phonePattern = /^[0-9]{10,11}$/;

        if (!name || !phone || !address) {
            alert("Vui lòng điền đầy đủ thông tin giao hàng.");
            return false;
        }

        if (!phonePattern.test(phone)) {
            alert("Số điện thoại không hợp lệ. Vui lòng nhập 10-11 chữ số.");
            return false;
        }
    }

    return confirm("Bạn chắc chắn muốn đặt đơn hàng?");
}