function toggleDescription() {
    const type = document.getElementById("type").value;
    const descSection = document.getElementById("descriptionSection");
    descSection.style.display = (type === "gallery") ? "block" : "none";
}

window.onload = toggleDescription;