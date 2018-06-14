require_relative "sequence"
module Json_Helper
  def render_collection(resources)
    render json: resources.page(params[:page]).per(params[:per])
  end

  def render_item(item)
    if item.errors.empty?
      sequence = Helpers::Sequence.new
      render json: item, sequence: sequence
    else
      render json: { errors: item.errors }, status: 400
    end
  end

  def render_error(errors, status)
    render json: { errors: errors }, status: status
  end
end