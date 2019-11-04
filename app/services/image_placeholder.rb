module ImagePlaceholder
  module_function

  PARAMS = {
    width: 3,
    height: 3,
    palette: %w[#79b1c0 #9d66ba #88cea6 #e03997 #ffffff]
  }.freeze

  def base64
    Mosaiq::Image.new(PARAMS).svg.to_base64
  end
end
