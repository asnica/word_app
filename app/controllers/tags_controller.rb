class TagsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.all.order(created_at: :desc)
    @user = current_user
    @user.tags.build if @user.tags.empty?
  end

  def update_tags
    if current_user.update(user_params)
      redirect_to tags_path, notice: "タグを登録しました。"
    else
      @tags = Tag.all
      render :index, status: :unprocessable_entity
    end
  end

  def create
    @tag = current_user.tags.build(tag_params)
    if @tag.save
      redirect_to tags_path, notice: "タグを登録しました。"
    else
      @tags = current_user.tags.all
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    # before_action(correct_user)で@tagを探す
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: "タグを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: "タグを削除しました。", status: :see_other
  end


  private

  def user_params
    params.fetch(:user, {}).permit(tags_attributes: [:id, :name, :_destroy])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def correct_user
    @tag = current_user.tags.find_by(id: params[:id])
    redirect_to tags_path, alert: "権限がありません。" if @tag.nil?
  end

end