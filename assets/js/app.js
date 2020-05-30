// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"

const getId = (e) => {
  return Number(e.target.id.split("-")[1])
} 

let Hooks = {}
Hooks.draggable_hook = {
  mounted() {
    this.el.addEventListener("mousedown", e => {
      console.log("started drag")
      const params = {
        id: getId(e),
        clientX: e.screenX,
        clientY: e.screenY
      }
      this.pushEvent("started_drag", params)
    })
 
    this.el.addEventListener("mouseleave", e => {
      // console.log("stopped drag")
      // this.pushEvent("stopped_drag", {id: getId(e)})
    })               
  }
}

Hooks.space_hook = {
  mounted() {
    this.el.addEventListener("mousemove", e => {
      const params = {
        clientX: e.screenX,
        clientY: e.screenY,
      }
      this.pushEvent("drag_move", params)
    })  
    this.el.addEventListener("mouseup", e => {
      console.log("mouseup")
      this.pushEvent("stopped_drag", {})
    })               
  }
}

Hooks.delete_sticker_hook = {
  mounted() {
    this.el.addEventListener("mousedown", e => {
      e.preventDefault()
      e.stopPropagation()
    })       
    this.el.addEventListener("mouseup", e => {
      e.preventDefault()
      e.stopPropagation()
    })
    this.el.addEventListener("mouseclick", e => {
      e.preventDefault()
      e.stopPropagation()
    })          
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
>> liveSocket.enableLatencySim(100)
window.liveSocket = liveSocket
