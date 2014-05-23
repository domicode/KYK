    class ImportController < ApplicationController
        require 'net/http'
        require 'net/https'
        require 'uri'
        require 'rexml/document'

        def authenticate
          @title = "Google Authetication"

          client_id = Figaro.env.google_key
          google_root_url = "https://accounts.google.com/o/oauth2/auth?state=profile&redirect_uri="+googleauth_url+"&response_type=code&client_id="+client_id.to_s+"&approval_prompt=force&scope=https://www.google.com/m8/feeds/"
          redirect_to google_root_url
        end

        def authorise
          begin
            @title = "Google Authetication"
            token = params[:code]
            client_id = Figaro.env.google_key
            client_secret = Figaro.env.google_secret
            uri = URI('https://accounts.google.com/o/oauth2/token')
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Post.new(uri.request_uri)

            request.set_form_data('code' => token, 'client_id' => client_id, 'client_secret' => client_secret, 'redirect_uri' => googleauth_url, 'grant_type' => 'authorization_code')
            response = http.request(request)
            response.code
            access_keys = ActiveSupport::JSON.decode(response.body)

            uri = URI.parse("https://www.google.com/m8/feeds/contacts/default/full?oauth_token="+access_keys['access_token'].to_s+"&max-results=50000&alt=json")

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Get.new(uri.request_uri)
            response = http.request(request)


            contacts = ActiveSupport::JSON.decode(response.body)

            # Starting from here we start taking apart the response and save it
            contacts['feed']['entry'].each_with_index do |contact,index|

             name = contact['title']['$t']

              # address = contact['gd$postalAddress'][0]['$t']
              contact['gd$email'].to_a.each do |email|
                email_address = email['address']
                @contact = current_user.contacts.new(:first_name => name, :email => email_address) 
              end

              @contact.first_name = name.split(" ")[0]
              @contact.last_name = name.split(" ")[1]

              # Here we get the picture for each contact, we need a new request for that with the contact id
              id = contact['id']['$t'].split("/").last
              uri = URI.parse("https://www.google.com/m8/feeds/photos/media/default/"+id+"/full?oauth_token="+access_keys['access_token'].to_s)
              http = Net::HTTP.new(uri.host, uri.port)
              http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
              request = Net::HTTP::Get.new(uri.request_uri)
              picture = http.request(request)
              p = picture.body

              # img = Magick::Image.from_blob(p).first
              # fmt = img.format
              # data=StringIO.new(p)
              # data.class.class_eval { attr_accessor :original_filename, :content_type }
              # data.original_filename = Time.now.to_i.to_s+"."+fmt
              # data.content_type='image.jpeg'
              # img.write(data.original_filename)

              file = StringIO.new(p) #mimic a real upload file
              file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
              file.original_filename = Time.now.to_i.to_s+".jpeg" #assign filename in way that paperclip likes
              file.content_type = "image/jpeg" # you could set this manually aswell if needed e.g 'application/pdf'

              @contact.avatar = file

              @contact.save

            end  

          rescue Exception => ex
             ex.message
          end

          redirect_to user_path(current_user), :notice => "You added your google contacts"


        end

    end
