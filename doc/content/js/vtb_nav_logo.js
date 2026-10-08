// Prepends the NRIC logo, linked to nric.inl.gov, to the left end of the
// header bar (VTB is an NRIC initiative, see doc/content/index.md).
document.addEventListener("DOMContentLoaded", function () {
  var home = document.getElementById("home-button");
  var wrapper = document.querySelector("nav .nav-wrapper");
  if (!home || !wrapper) {
    return;
  }

  // "home-button" links to this page's relative path to index.html, so
  // stripping that off gives the relative path back to the site root.
  var root = home.getAttribute("href").replace(/index\.html(?:[?#].*)?$/, "");

  var a = document.createElement("a");
  a.href = "https://nric.inl.gov/";
  a.className = "left nric-nav-logo";

  var img = document.createElement("img");
  img.src = root + "media/nric_logo.png";
  img.alt = "The National Reactor Innovation Center (NRIC) logo";
  a.appendChild(img);

  wrapper.insertBefore(a, wrapper.firstChild);
});
