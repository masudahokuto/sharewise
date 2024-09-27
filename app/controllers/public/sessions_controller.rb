class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]
  before_action :redirect_if_admin_signed_in, only: [:new, :create]

  def create
    sign_out(current_admin) if admin_signed_in?
    super
  end

  def after_sign_in_path_for(resource)
     mypage_users_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private
  # アクティブであるかを判断するメソッド
  def user_state
    # 【処理内容1】 入力されたemailからアカウントを1件取得
    user = User.find_by(email: params[:user][:email])
    # 【処理内容2】 アカウントを取得できなかった場合、このメソッドを終了する
    return if user.nil?
    # 【処理内容3】 取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了する
    return unless user.valid_password?(params[:user][:password])

    # 【処理内容4】 アクティブでない会員に対する処理
    if user.is_active == false
      flash[:alert] = "アカウントが無効です。管理者にお問い合わせください。"
      redirect_to new_user_registration_path
    end
  end

  private

  def redirect_if_admin_signed_in
    if admin_signed_in?
      redirect_to admin_users_path, alert: "アドミンとしてログインしています。"
    end
  end
end
