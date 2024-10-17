import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "script.js"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()
// require('./preview')
import './preview'
import './valid_color'
import './auto_scroll'
//import './category_name_edit'
//import './title_name_edit'
// import './clock'

// window.addEventListener('popstate', function (e) {
// window.location.reload();
// console.log("Reload!");
// });