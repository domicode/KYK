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

            contacts['feed']['entry'].each_with_index do |contact,index|

               name = contact['title']['$t']
               # address = contact['gd$postalAddress'][0]['$t']
               contact['gd$email'].to_a.each do |email|
                email_address = email['address']
                current_user.contacts.create(:first_name => name, :email => email_address)  # for testing i m pushing it into database..
              end

            end  
          rescue Exception => ex
             ex.message
          end

          redirect_to user_path(current_user), :notice => "Invite or follow your Google contacts."


        end

    end
