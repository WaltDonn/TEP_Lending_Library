SecureHeaders::Configuration.default do |config|
    #https://github.com/twitter/secureheaders
    #If you would like to use a default configuration (which is fairly locked down), 
    #just call SecureHeaders::Configuration.default without any arguments or block
    
    
    config.csp = {
        # "meta" values. these will shape the header, but the values are not included in the header.
        preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.
    
        # directive values: these values will directly translate into source directives
        default_src: %w('self'),
        base_uri: %w('self'),
        block_all_mixed_content: false, # see http://www.w3.org/TR/mixed-content/
        child_src: %w('self'), # if child-src isn't supported, the value for frame-src will be set.
        connect_src: %w(wss:),
        font_src: %w('self' https://maxcdn.bootstrapcdn.com/font-awesome/ data:),
        form_action: %w('self'),
        frame_ancestors: %w('none'),
        img_src: %w('self'),
        manifest_src: %w('self'),
        media_src: %w('self'),
        object_src: %w('self'),
        sandbox: false,
        plugin_types: %w(application/x-shockwave-flash),
        script_src: %w('self' 'unsafe-inline' https://ajax.googleapis.com/ajax/libs/),
        style_src: %w('unsafe-inline' 'self' https://ajax.googleapis.com/ajax/libs/jqueryui/ https://maxcdn.bootstrapcdn.com/font-awesome/),
        worker_src: %w('self'),
        upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
       
  }
    
end