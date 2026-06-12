class WordsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [ :edit, :update, :destroy ]
  before_action :format_synonym_params, only: [ :create, :update ]

  def index
    @words = Word.search(params)
    respond_to do |format|
      format.html do
        @words = @words.page(params[:page]).per(9)
      end
      format.csv do
        send_data @words.to_csv, filename: "word_master_#{Time.zone.now.strftime('%Y%m%d%H%M')}.csv"
      end
    end
  end

  def show
    @word = Word.find_by_hashid!(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to words_path, alert: "存在しない単語です。"
  end

  def new
    @word = current_user.words.build
  end

  def create
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
    if @word.update(word_params)
      redirect_to params[:return_to] || words_path, notice: "単語を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @word.soft_delete
    redirect_to params[:return_to] || words_path, notice: "単語を削除しました。", status: :see_other
  rescue ActiveRecord::InvalidForeignKey
    redirect_to params[:return_to] || words_path, alert: "この単語は問題集で使用されているため、削除できません。"
  end

  private

  def word_params
    params.require(:word).permit(:name, :meaning, :note, :image, :synonym, :remove_image, tag_ids: [], synonym: [])
  end

  def correct_user
    @word = current_user.words.find_by_hashid!(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to words_path, alert: "権限がないか、無効なアクセスです。"
  end

  def format_synonym_params
    if params[:word] && params[:word][:synonym].is_a?(Array)
      params[:word][:synonym] = params[:word][:synonym].join(",")
    end
  end
end
