module UploadifyRailsHelper
  def uploadify_options(options = {})
    @uploadify_options ||= {:dialog_file_description => options[:dialog_file_description] || "Photos",
                            :allowed_extensions      => options[:allowed_extensions] || Photo::EXTENSIONS,
                            :max_size                => options[:max_size] || Photo::MAX_SIZE,
                            :allow_multiple_files    => options[:allow_multiple_files] || true,
                            :url                     => options[:url] || photos_path,
                            :id                      => options[:id] || "photo_photo"}
  end
  
  def javascript_uploadify_tag
    javascript_tag(%(
    
    $(document).ready(function() {
      $('##{uploadify_options[:id]}').uploadify({
        uploader      : '/javascripts/uploadify/uploadify.swf',
        script        : '#{ uploadify_options[:url] }',
        fileDataName  : $('##{uploadify_options[:id]}')[0].name, // Extract correct name of upload field from form field
        cancelImg     : '/images/cancel.png',
        buttonText    : 'Browse',
        fileDesc      : '#{uploadify_options[:dialog_file_description]} (#{allowed_extensions})',
        fileExt       : '#{allowed_extensions}',
        sizeLimit     : #{uploadify_options[:max_size]},    
        multi         : #{uploadify_options[:allow_multiple_files] },
        onComplete    : function(event, queueID, fileObj, response, data) { var data = eval('(' + response + ')');$.getScript(data.photo)},
        onAllComplete : function(event, data){
          $('#uploadify_cancel').hide('blind');
          $('#uploadify_submit').show('blind');      
        },
        onSelect: function(event, queueID, fileObj){
          if (fileObj.size > #{uploadify_options[:max_size]}) {
            alert('The image' + fileObj.name + ' is too large.')
            return false;
          }
        },  
        scriptData  : {
            'format': 'json', 
            '#{get_session_key_name}' : encodeURIComponent('#{get_session_key}'),
            'authenticity_token'      : encodeURIComponent('#{get_authenticity_token}')
        }    
      });
    });))
    
  end
  
  def render_uploadify(options = {})
    uploadify_options(options) #sets uploadify options
    javascript_tag("window._token = '#{get_authenticity_token}'") <<
    javascript_include_tag("uploadify/swfobject") << 
    javascript_include_tag("uploadify/jquery.uploadify.v2.1.0.min") <<
    javascript_uploadify_tag
  end
  
  def uploadify_cancel(text = "Cancel", options = {})
    link_to_function text, {:id => "uploadify_cancel", :style => "display:none"}.merge(options) do |page|
      page << "$('##{uploadify_options[:id]}').uploadifyClearQueue();
               $('#uploadify_cancel').hide();
               $('#uploadify_submit').show()"
    end
  end
  
  def uploadify_submit(text = "Upload", options = {})
    link_to_function text, {:class => "button", :id => "uploadify_submit"}.merge(options) do |page|
      page << "$('##{uploadify_options[:id]}').uploadifyUpload();
               $('#uploadify_submit').hide();
               $('#uploadify_cancel').show()"
    end
  end
  
  def get_authenticity_token
    u form_authenticity_token if protect_against_forgery?
  end
  
  def get_session_key_name
    ActionController::Base.session_options[:key]
  end
  
  def get_session_key
    u cookies[get_session_key_name]
  end
  
  def allowed_extensions
    uploadify_options[:allowed_extensions].collect { |ext| "*.#{ext}" }.join(';')
  end
end