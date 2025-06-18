function toggleDropdown() {
    const menu = document.getElementById("dropdownMenu");
    menu.style.display = menu.style.display === "block" ? "none" : "block";
}

window.onclick = function (event) {
    if (!event.target.closest('.user-dropdown')) {
        const menu = document.getElementById("dropdownMenu");
        if (menu)
            menu.style.display = "none";
    }
}