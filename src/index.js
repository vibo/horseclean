import { Elm } from "./Main.elm";
import "./index.css";

document.addEventListener("DOMContentLoaded", () => {
  Elm.Main.init({
    node: document.getElementById("root"),
    // flags: "Initial Message",
  });
});
