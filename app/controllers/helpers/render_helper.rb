require_relative "sequence"
def render_collection(resources)
  unless resources.nil?
    render json: resources.page(params[:page]).per(params[:per])
  else
    render json: {}
  end
end

def render_item(item)
  sequence = Sequence.new
  render json: item, sequence: sequence
end

def render_error(params, errors, status)
  render json: {params: params, errors: errors}, status: status
end