import { Controller } from "@hotwired/stimulus"
import Carousel from 'stimulus-carousel'

application.register('carousel', Carousel)

// Connects to data-controller="stimulus-carousel"
export default class extends Controller {
  connect() {
    super.connect()
    console.log('Do what you want here.')

    // The swiper instance.
    this.swiper

    // Default options for every carousels.
    this.defaultOptions
  }

  // You can set default options in this getter.
  get defaultOptions() {
    return {
      // Your default options here
    }
  }
}
