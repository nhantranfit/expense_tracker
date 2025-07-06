WickedPdf.config = {
  # Path to the wkhtmltopdf executable
  exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf'),

  # Default options for PDF generation
  default_options: {
    page_size: 'A4',
    print_media_type: true,
    disable_javascript: false,
    disable_internal_links: false,
    disable_external_links: false,
    encoding: 'UTF-8',
    margin: {
      top: 10,
      bottom: 10,
      left: 10,
      right: 10
    }
  }
}
