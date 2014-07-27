class PrintToolsController < ApplicationController
  # GET
  def print
    # All handled by Rails magic...
  end

  # POST
  def do_print
    uploaded_io = params[:to_print]

    path = Rails.root.join('private', 'uploads', uploaded_io.original_filename)

    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    # # Use the default printer
    # pj = Cups::PrintJob.new(path)

    # pj.print

    puts `lp "#{path}"`

    @message = 'Print successful!'

    render 'print'
  end

  def clear_cache
    FileUtils.rm_rf(Dir.glob(Rails.root.join('private', 'uploads', '*')))

    render :nothing => true
  end
end
