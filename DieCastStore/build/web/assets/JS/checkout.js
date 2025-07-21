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
            alert("Please fill in the shipping information completely.");
            return false;
        }

        if (!phonePattern.test(phone)) {
            alert("Invalid phone number. Please enter 10-11 digits.");
            return false;
        }
    }

    return confirm("Are you sure you want to place an order?");
}