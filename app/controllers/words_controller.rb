class WordsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:query].present?
      # 単語名の曖昧検索
      @words = Word.where("name LIKE ?", "%#{params[:query]}%")
    else
      @words = Word.all
    end
  end

  def show
    @word = Word.find(params[:id])
  end

  def new
    @word = current_user.words.build
  end

  def create
    params[:word][:synonym] = params[:word][:synonym].join(',') if params[:word][:synonym].is_a?(Array)
    @word = current_user.words.build(word_params)
    if @word.save
      redirect_to words_path, notice: "単語を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # before_action(correct_user)で@wordを探す
  end

  def update
    params[:word][:synonym] = params[:word][:synonym].join(',') if params[:word][:synonym].is_a?(Array)
    @word = Word.find(params[:id])
    if @word.update(word_params)
      redirect_to words_path, notice: "単語を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @word.destroy
    redirect_to words_path, notice: "単語を削除しました。", status: :see_other
  end

  private

  def word_params
    params.require(:word).permit(:name, :meaning, :note, :synonym, :image, :remove_image, tag_ids: [], synonym: [])
  end

  def correct_user
    @word = current_user.words.find_by(id: params[:id])
    redirect_to words_path, alert: "権限がありません。" if @word.nil?
  end

end