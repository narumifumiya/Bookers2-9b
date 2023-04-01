class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # book.rbに記述したスコープを使用して@userのbooksで各日付けでcreateしたbookを代入する
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def daily_posts

    user = User.find(params[:user_id])
    # userのbooksからcreated_atカラムのデータを検索する（全ての日から）
    # 非同期通信のjs.erbで使用する為、@booksとしている
    @books = user.books.where(created_at: params[:created_at].to_date.all_day)
    # viewでフォームは非同期としている為、daily_postsアクションが実行されるとdaily_posts_form.js.erbを読み込みに行く（非同期通信をする。）
    render :daily_posts_form
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
