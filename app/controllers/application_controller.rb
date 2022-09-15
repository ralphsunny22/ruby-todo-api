class ApplicationController < ActionController::API

    def encode_token(payload)
        JWT.encode(payload, 'secret')
    end

    def decode_token
        # Authorization: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ETUYUOkmfnWsWIvA8iBOkE2s1ZQ0V_zgnG_c4QRrhbg"
        auth_header = request.headers['Authorization']
        # auth_header = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ETUYUOkmfnWsWIvA8iBOkE2s1ZQ0V_zgnG_c4QRrhbg"
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, 'secret', true, algorithm: 'HS256') #[{"user_id"=>1}, {"alg"=>"HS256"}]
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def authorized_user
        decoded_token = decode_token()
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorize
        #unless means this fxn will only run when 'authorized_user' is 'nil'
        #render json: { message: 'You have to login in' }, status: :unathorized unless
        @response = {
            :status => 400,
            :message => "You have to login in",
        }
        render json: @response, status: 400 unless
        authorized_user
    end

end
