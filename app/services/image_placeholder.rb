module ImagePlaceholder
  module_function

  PARAMS = {
    width: 3,
    height: 3,
    palette: %w[#217d97 #5c008c #119e4d #60d83e #fb00aa #ffffff]
  }.freeze

  def base64
    Mosaiq::Image.new(PARAMS).svg.to_base64
  end
end
