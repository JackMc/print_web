class PrintToolsController < ApplicationController
  # GET
  def print
    # All handled by Rails magic...
  end

  # POST
  def do_print
    ext_convert = [".odt", ".docx", ".doc"]
    ext_fine = [".png", ".pdf", ".jpeg"]
    supported_exts = ext_convert + ext_fine
    
    uploaded_io = params[:to_print]

    if !uploaded_io
        @message = 'Please choose a file.'
        render 'print'
        return
    end

    print_pwd = params[:print_pwd]

    if print_pwd != ENV['printer_password']
        @message = 'Incorrect printer password'
        puts ENV['printer_password']
        render 'print'
        return
    end

    path = Rails.root.join('private', 'uploads', uploaded_io.original_filename)

    File.open(path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @message = ''

    puts "#{path.extname}"
    if supported_exts.include? path.extname
      if ext_convert.include? path.extname
        @message = "Using currently not working conversion feature. Please convert to PDF first."
        # We need to convert the file
        #convert_output = `unoconv -f pdf #{path}`

        #if convert_output.downcase.include? "error"
        #  @message = "File incorrectly formatted for conversion."
        #else
        #  path.sub(".#{path.extname}", '.pdf')
        #end
      end
    else
      @message = "Error: Invalid file extension!"
    end

    if @message.empty?
      lp_out = `lp "#{path}"`
      @message = 'Print successful!'

      if lp_out.downcase.include? "error"
        @message = "Error while communicating with printer: #{lp_out}"
      end
    end


    render 'print'
  end

  def clear_cache
    FileUtils.rm_rf(Dir.glob(Rails.root.join('private', 'uploads', '*')))

    render :nothing => true
  end
end
