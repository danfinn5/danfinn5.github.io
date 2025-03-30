function checkPassword() {
    console.log("Password prompt is displayed.");
    var password = prompt("Enter the password to view this section:");
    console.log("Entered password:", password);
    if (password === "yourpassword") {
        console.log("Password is correct.");
        document.getElementById("protectedContent").style.display = "block";
        document.getElementById("wrongPassword").style.display = "none";
    } else {
        console.log("Password is incorrect.");
        document.getElementById("wrongPassword").style.display = "block";
    }
}