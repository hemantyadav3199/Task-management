class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:register, :login]

  def register
    user = User.new(user_params)
    user.status ||= :active

    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email], status: 'active')
    
    if user&.authenticate(params[:password])
      tokens = generate_tokens(user)
      render json: { user: user, tokens: tokens }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :status)
  end

  def generate_tokens(user)
    access_expiry = 1.hour.from_now.to_i
    refresh_expiry = 7.days.from_now.to_i
    {
      access_token: JsonWebToken.encode({ user_id: user.id, exp: access_expiry }),
      refresh_token: JsonWebToken.encode({ user_id: user.id, exp: refresh_expiry }),
      expires_in: {
      access_token: access_expiry,
      refresh_token: refresh_expiry
    }
    }
  end
end