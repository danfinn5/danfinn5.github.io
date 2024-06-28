function checkPassword() {
    var password = prompt("Enter the password to view this section:");
    if (password === "DFSamples2024") {
        document.getElementById("protectedContent").style.display = "block";
        document.getElementById("wrongPassword").style.display = "none";
    } else {
        document.getElementById("wrongPassword").style.display = "block";
    }
}