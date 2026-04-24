class TagsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:query].present?
      # タグ名の曖昧検索
      @tags = Tag.where("name LIKE ?", "%#{params[:query]}%")
    else
      @tags = Tag.all
    end
    @tag = Tag.new
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

  def tag_params
    params.require(:tag).permit(:name)
  end

  def correct_user
    @tag = current_user.tags.find_by(id: params[:id])
    redirect_to tags_path, alert: "権限がありません。" if @tag.nil?
  end

end